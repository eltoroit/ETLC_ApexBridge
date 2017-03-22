/*
Code developed by: http://eltoro.it - May 1, 2016
Twitter: https://twitter.com/ElToroIT
LinkedIn: https://www.linkedin.com/in/eltoroit
Repository: https://github.com/eltoroit/ETLC_SecureDB

Because Apex runs in System mode, it has access to all the objects (CRED) and fields (FLS),
independent of the actual permissions the running may have in such objects and fields.

This code performs checks required to guarantee your code is safe by checking the actual
permissions the running user has on the data.

This code has three main modes:
1. Queries: By either providing a SOQL query (ETLC_SecuredDB.query), a single record or a list
of records (ETLC_SecuredDB.validateQuery). If you use the query, the sytem will also perform the
query from the database.

2. DMLs: By either providing a single record or a list of records (ETLC_SecuredDB.performDML)
and the operation desired (ETLC_SecuredDB.Operation), this class will validate the user has the
required permissions in the objects and fields involved before attempting submitting the request
to the database.

Note: This class inspects the data to find the objects and fields involved before validating the
access the user has on the data. This may be a slow operation if you have a big dataset (may records,
many fields, many relationships). You may optionally handle the database requests yourself (Query, DML)
and use this class to only validate your data. There is no reason to always find the objects/fields
at runtime if the data structure is not changing.

3. Plain validator:
3a. Finding fields: In order to take advantage of not having to validate the data structure everytime 
you run this code, you may get the field structure as a string (ETLC_SecuredDB.getFieldsForPlainValidator)
and pass that structure to the validator (ETLC_SecuredDB.plainValidator).

3b. Passing Fields: If you don't want this class to inspecting your data structure, and you only
want to use it as a validator, you'll invoke the ETLC_SecuredDB.plainValidator() method passing
the operation (ETLC_SecuredDB.Operation) and the fields to chack. You can either pass a string obtained by
running the ETLC_SecuredDB.getFieldsForPlainValidator() method, or pass the object and set of fields.

Note:
https://github.com/eltoroit/ETLC_SecureDB/issues/1
- I am not sure which method is more efficient, so I will make both and do some performance tests and
comparing results by setting the flag  
*/ 
public with sharing class ETLC_SecuredDB {
    // Performance testing
    public static Boolean findFieldsUsingJSON = false;
    
    // Do you want this code to generate debug logs? 
    public static Boolean showDebugMessages = false;
    
    // These are the different operations that can be checked
    public enum Operation {Querying, Inserting, Updating, Deleting, Upserting}
    
    // Query records by providing a SOQL query and validate if user has permissions
    public static List<sObject> query(String SOQL) {
        // First query... 
        List<sObject> dbRecords = Database.query(SOQL);
        // Then check for security... 
        // It sounds funny that you check security after query, but this is important because:
        // -- The SOQL is tought to parse (specially relationshp queries), have Apex/Salesforce parse it.
        // -- There could be syntax errors in the SOQL query, so why bother parsing if Salesforce is going to fail
        // -- Why bother checking security if there are no fields returned
        // -- Simple to make it work for SOSL too (same ideas)
        // -- Do you really need more reasons?
        validate(Operation.Querying, findFields(dbRecords));
        return dbRecords;
    } 
    
    // Provide a record (list of records) and check if user has read access on those records
    // This code will investigate which sObjects and fields it needs to validate.
    public static void validateQuery(sObject dbRecord) {
        List<sObject> dbRecords = new List<sObject>();
        dbRecords.add(dbRecord);
        validateQuery(dbRecords);
    }
    public static void validateQuery(List<sObject> dbRecords) {
        validate(Operation.Querying, findFields(dbRecords));
    }
    
    // Provide a record (list of records) and perform the operation desired.
    // For updates, you must pass a list of records
    public static void performDML(Operation op, sObject dbRecord) {
        if (op == Operation.upserting) {
            throw new ETLC_Exception('When upserting records, you must pass a list of records');
        }
        List<sObject> dbRecords = new List<sObject>();
        dbRecords.add(dbRecord);
        performDML(op, dbRecords);
    }
    public static void performDML(Operation op, List<sObject> dbRecords) {
        if (showDebugMessages) {
            Set<String> sObjNames = new Set<String>();
            for (sObject dbRecord : dbRecords) {
                String sObjName = dbRecord.getsObjectType().getDescribe().getName();
                if (!sObjNames.contains(sObjName)) sObjNames.add(sObjName);
            }
            System.debug(op + ' on ' + sObjNames);
        }
        
        // First check for security...
        validate(op, findFields(dbRecords));
        // Then perform DML operation...
        Integer counterDMLBefore = Limits.getDMLStatements();
        if (op == Operation.Inserting) insert dbRecords;
        if (op == Operation.Querying)  throw new ETLC_Exception('I thought you were doing a DML');
        if (op == Operation.Updating) update dbRecords;
        if (op == Operation.Deleting) delete dbRecords;
        if (op == Operation.Upserting) upsert dbRecords;
        if (counterDMLBefore+1 != Limits.getDMLStatements()) throw new ETLC_Exception('Which DML Did you perform?');
    }
    
    // Obtain a string representing the objects and fields that you can use to validate security
    public static String getFieldsForPlainValidator(sObject dbRecord) {
        List<sObject> dbRecords = new List<sObject>();
        dbRecords.add(dbRecord);
        return getFieldsForPlainValidator(dbRecords);
    }
    public static String getFieldsForPlainValidator(List<sObject> dbRecords) {
        Map<String, Set<String>> mapFieldNames = findFields(dbRecords);
        return JSON.serialize(mapFieldNames);
    }
    
    // Throws System.NoAccessException if there are Security failures.
    public static void plainValidator(Operation op, String sObjName, Set<String> fieldNames) {
        Map<String, Set<String>> mapFieldNames = new Map<String, Set<String>>();
        mapFieldNames.put(sObjName, fieldNames);
        validate(op, mapFieldNames);
    }
    public static void plainValidator(Operation op, String fields) {
        Map<String, Set<String>> mapFieldNames;
        mapFieldNames = (Map<String, Set<String>>) JSON.deserialize(fields, Map<String, Set<String>>.class);
        validate(op, mapFieldNames);
    }
    
    // Throws System.NoAccessException if there are Security failures
    private static void validate(Operation op, Map<String, Set<String>> mapFieldNames) {
        String securityMessage;
        Map<String, Schema.SObjectType> mapObjects = Schema.getGlobalDescribe(); 
        for (String sObjectName : mapFieldNames.keySet()) {
            securityMessage = 'CRUD on [' + sObjectName + '] for [' + op + ']';
            if (showDebugMessages) {
                System.debug('Checking: ' + securityMessage);
            }

            // Does Object exist?
            Schema.DescribeSObjectResult drSObj;
            try {
				drSObj = mapObjects.get(sObjectName).getDescribe();
        	} catch (Exception ex){
            	throw new ETLC_Exception('Invalid Object name [' + sObjectName + ']');
        	}

            if (op == Operation.Inserting) {
                if (!drSObj.isCreateable()) throwSecurityException(securityMessage);
            } else if (op == Operation.Querying) {
                if (!drSObj.isAccessible()) throwSecurityException(securityMessage);
            } else if (op == Operation.Updating) {
                if (!drSObj.isUpdateable()) throwSecurityException(securityMessage);
            } else if (op == Operation.Deleting) {
                if (!drSObj.isDeletable())  throwSecurityException(securityMessage);
            } else if (op == Operation.Upserting) {
                if (!drSObj.isCreateable()) throwSecurityException(securityMessage + '[Create]');
                if (!drSObj.isUpdateable()) throwSecurityException(securityMessage + '[Update]');
            } else {
                throw new ETLC_Exception('What operation were you performing?');
            }
            
            if (op != Operation.Deleting) {
                // A field can't be deleted.... the whole record is deleted, so no need to check fields on delete ;-)
                Map<String,Schema.SObjectField> mapFields = drSObj.fields.getMap();
                for (String fieldName : mapFieldNames.get(sObjectName)) {
                    
                    // Does field exist?
                    Schema.DescribeFieldResult drField;
                    try {
                        drField = mapFields.get(fieldName).getDescribe();
                    } catch (Exception ex){
                        throw new ETLC_Exception('Invalid field name [' + fieldName + ']');
                    }
                    
                    if (drField.isPermissionable()) {
                        securityMessage = 'FLS on [' + sObjectName + '.' + fieldName + '] for [' + op + ']';
                        if (showDebugMessages) {
                            System.debug('Checking: ' + securityMessage);
                        }
                        if (op == Operation.Inserting) {
                            if (!drField.isCreateable()) throwSecurityException(securityMessage);
                        } else if (op == Operation.Querying) {
                            if (!drField.isAccessible()) throwSecurityException(securityMessage);
                        } else if (op == Operation.Updating) {
                            if (!drField.isUpdateable()) throwSecurityException(securityMessage);
                        } else if (op == Operation.Upserting) {
                            if (!drField.isCreateable()) throwSecurityException(securityMessage + '[Create]');
                            if (!drField.isUpdateable()) throwSecurityException(securityMessage + '[Update]');
                        } else {
                            throw new ETLC_Exception('What operation were you performing?');
                        }
                    } else {
                        if (showDebugMessages) {
                            System.debug('Bypass Check: FLS on [' + sObjectName + '.' + fieldName + '] for [' + op + '] since it\'s not isPermissionable()');
                        }
                    }                    
                }
            }
        }
    }
    
    // Find fields from list of records
    private static Map<String, Set<String>> findFields(List<sObject> dbRecords) {
        if (findFieldsUsingJSON) {
            return findFields_Method01(dbRecords);
        } else {
            return findFields_Method02(dbRecords);
        }
    }  
    private static Map<String, Set<String>> findFields_Method01(List<sObject> dbRecords) {
        String strJSON;
        Map<String, Set<String>> mapFields;
        
        strJSON = JSON.serialize(dbRecords);
        if (showDebugMessages) {
            System.debug('JSON:' + strJSON);
        }
        mapFields = new Map<String, Set<String>>();
        List<Object> records = (List<Object>) JSON.deserializeUntyped(strJSON);
        for (Object record : records) {
            findFieldsRecursive_Method01(mapFields, (Map<String, Object>) record);
        }
        if (showDebugMessages) {
            for (String objectName : mapFields.keySet()) {
                System.debug(objectName + ': ' + mapFields.get(objectName));
            }
        }
        return mapFields;
    }
    private static void findFieldsRecursive_Method01(Map<String, Set<String>> mapFields, Map<String, Object> record) {
        String strAttributes = 'attributes';
        String strRecord = 'records';
        if (record.containsKey(strAttributes)) {
            Map<String, Object> attributes = (Map<String, Object>) record.get(strAttributes);
            String objectName = (String) attributes.get('type');
            for (String fieldName : record.keySet()) {
                Object field = record.get(fieldName);
                if (fieldName == strAttributes) {
                    // Do nothing, already processed
                } else if (field instanceof Map<String, Object>) {
                    findFieldsRecursive_Method01(mapFields, (Map<String, Object>) field);
                } else {
                    Set<String> fieldNames = new Set<String>();
                    if (mapFields.containsKey(objectName)) fieldNames = mapFields.get(objectName);
                    fieldNames.add(fieldName);
                    mapFields.put(objectName, fieldNames);
                }
            }            
        } else if (record.containsKey(strRecord)) {
            List<Object> children = (List<Object>) record.get('records');
            for (Object child : children) {
                findFieldsRecursive_Method01(mapFields, (Map<String, Object>) child);
            }
        } else {
            // Can't force in testing...
            System.debug(record);
            throw new ETLC_Exception('Why not?');
        }
    }
    private static Map<String, Set<String>> findFields_Method02(List<sObject> dbRecords) {
        Map<String, Set<String>> mapFields = new Map<String, Set<String>>();
        for (sObject dbRecord : dbRecords) {
            findFieldsRecursive_Method02(mapFields, dbRecord);
        }
        if (showDebugMessages) {
            for (String objectName : mapFields.keySet()) {
                System.debug(objectName + ': ' + mapFields.get(objectName));
            }
        }
        return mapFields;
    }
    private static void findFieldsRecursive_Method02(Map<String, Set<String>> mapFields, sObject dbRecord) {
        String objectName = dbRecord.getsObjectType().getDescribe().getName();
        Map<String, Object> fields = dbRecord.getPopulatedFieldsAsMap();
        for (String fieldName : fields.keyset()) {
            Object fieldValue = fields.get(fieldName);
            if (fieldValue instanceof List<sObject>) {
                // Children
                List<sObject> children = (List<sObject>) fieldValue;
                for (sObject child : children) {
                    findFieldsRecursive_Method02(mapFields, child);
                }
            } else if (fieldValue instanceof sObject) {
                // Parent
                findFieldsRecursive_Method02(mapFields, (sObject) fieldValue);
            } else {
                // Field
                Set<String> fieldNames = new Set<String>();
                if (mapFields.containsKey(objectName)) fieldNames = mapFields.get(objectName);
                fieldNames.add(fieldName);
                mapFields.put(objectName, fieldNames);
            }
        }
    } 
    
    // Security exception thrower
        private static void throwSecurityException(String message) {
        // Security messages must be very vague!
    	if (!Test.isRunningTest()) throw new System.NoAccessException();
        if (Test.isRunningTest())  throw new ETLC_Exception(message);
    }
}