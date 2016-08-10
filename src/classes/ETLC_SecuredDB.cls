/*
Code developed by: http://eltoro.it - May 1, 2016
Twitter: https://twitter.com/ElToroIT
LinkedIn: https://www.linkedin.com/in/eltoroit
Repository: https://github.com/eltoroit/ETLC_SecureDB
*/
public with sharing class ETLC_SecuredDB {
	public enum Operation {Querying, Inserting, Updating, Deleting, Upserting}
	public Boolean debug = false;

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
    public static void validateQuery(sObject dbRecord) {
        List<sObject> dbRecords = new List<sObject>();
        dbRecords.add(dbRecord);
        validateQuery(dbRecords);
    }
    public static void validateQuery(List<sObject> dbRecords) {
        validate(Operation.Querying, findFields(dbRecords));
    }
    public static void performDML(Operation op, sObject dbRecord) {
		if(op == Operation.upserting){
			throw new ETLC_Exception('Use another version of performDML when using Upsert');
		}
        List<sObject> dbRecords = new List<sObject>();
        dbRecords.add(dbRecord);
        performDML(op, dbRecords);
    }
    public static void performDML(Operation op, List<sObject> dbRecords) {
		// First check for security...
		validate(op, findFields(dbRecords));
		// Then perform DML operation...
		Integer counterDMLBefore = Limits.getDMLStatements();
		if (op == Operation.Inserting) insert dbRecords;
		if (op == Operation.Querying)  throw new ETLC_Exception('I thought you were doing a DML');
		if (op == Operation.Updating) update dbRecords;
		if (op == Operation.Deleting) delete dbRecords;
		if (op == Operation.Upserting) upsert dbRecords;
        if (counterDMLBefore+1 != Limits.getDMLStatements()) {
            throw new ETLC_Exception('Which DML Did you perform?');
        }
	}

	// Throws exception if there are Security failures
	// private static void validate(Operation op, List<sObject> dbRecords) {
	//	validate(op, findFields(dbRecords));
	// }
	private static void validate(Operation op, Map<String, Set<String>> mapFieldNames) {
        String securityMessage;
		Map<String, Schema.SObjectType> mapObjects = Schema.getGlobalDescribe(); 
		for (String sObjectName : mapFieldNames.keySet()) {
            securityMessage = 'CRUD on [' + sObjectName + '] for [' + op + ']';
			if(debug){System.debug('Checking: ' + securityMessage)};
			Schema.DescribeSObjectResult drSObj = mapObjects.get(sObjectName).getDescribe();
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
				// A field can't be deleted.... the whole record is deleted ;-)
				Map<String,Schema.SObjectField> mapFields = drSObj.fields.getMap();
				for (String fieldName : mapFieldNames.get(sObjectName)) {
					Schema.DescribeFieldResult drField = mapFields.get(fieldName).getDescribe();
					if (drField.isPermissionable()) {
                        securityMessage = 'FLS on [' + sObjectName + '.' + fieldName + '] for [' + op + ']';
						if(debug){System.debug('Checking: ' + securityMessage);}
						if (op == Operation.Inserting) {
							if (!drField.isCreateable()) throwSecurityException(securityMessage);
						} else if (op == Operation.Querying) {
							if (!drField.isAccessible()) throwSecurityException(securityMessage);
						} else if (op == Operation.Updating) {
							if (!drField.isUpdateable()) throwSecurityException(securityMessage);
						} else if (op == Operation.Deleting) {
							throw new ETLC_Exception('What are you doing here?');
						} else if (op == Operation.Upserting) {
							if (!drField.isCreateable()) throwSecurityException(securityMessage + '[Create]');
							if (!drField.isUpdateable()) throwSecurityException(securityMessage + '[Update]');
						} else {
							throw new ETLC_Exception('What operation were you performing?');
						}
					} else {
						System.debug('Bypass Check: FLS on [' + sObjectName + '.' + fieldName + '] for [' + op + '] since it\'s not isPermissionable()');   
					}                    
				}
			}
		}
	}

	// Find fields from list of records
	private static Map<String, Set<String>> findFields(List<sObject> dbRecords) {
		String strJSON;
		Map<String, Set<String>> mapFields;
	
		strJSON = JSON.serialize(dbRecords);
		if(debug){System.debug('JSON:' + strJSON);}
		mapFields = new Map<String, Set<String>>();
		List<Object> records = (List<Object>) JSON.deserializeUntyped(strJSON);
		for (Object record : records) {
			findFieldsRecursive(mapFields, (Map<String, Object>) record);
		}
		if(debug) {
			for (String objectName : mapFields.keySet()) {
				System.debug(objectName + ': ' + mapFields.get(objectName));
			}
		}
		return mapFields;
	}
	private static void findFieldsRecursive(Map<String, Set<String>> mapFields, Map<String, Object> record) {
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
					findFieldsRecursive(mapFields, (Map<String, Object>) field);
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
				findFieldsRecursive(mapFields, (Map<String, Object>) child);
			}
		} else {
			System.debug(record);
			throw new ETLC_Exception('Why not?');
		}
	}

	// Security exception thrower
    private static void throwSecurityException(String message) {
        if (Test.isRunningTest()) {
            throw new ETLC_Exception(message);
        } else {
            // Security messages must be very vague!
            throw new System.NoAccessException();
        }
        
    }
}