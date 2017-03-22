public class ETLC_ApexBridge_Controller {
    @AuraEnabled
    public static String execute(String dataJson) {
        ETLC_ApexBridge_Request request;
        // If there are any errors, the data will need to be reset... so, save a SavePoint
        Savepoint spAllDataChanges;
        try {
            System.debug('Input: ' + dataJson);
            request = ETLC_ApexBridge_Request.fromJSON(dataJson);
            if (request.debug) System.debug('Input Processed: ' + request);
            if (!request.doesCallout) {
                spAllDataChanges = Database.setSavepoint();
            }
            if (request.controller == null) {
                throw new ETLC_Exception('Did you provide a controller?');
            }
            if (request.method == null) {
                throw new ETLC_Exception('Did you provide a method?');
            }
            ETLC_ApexBridge_Abstract executor;
            try {
                executor = (ETLC_ApexBridge_Abstract) Type.forName(request.controller).newInstance();                
            } catch (Exception ex) {
                System.debug(ex);
                throw new ETLC_Exception('Did you provide a propper controller?');
            }
            executor.process(request);
            if (request.debug) System.debug('After: ' + request);
        } catch (Exception ex) {
            // Rollback the data changes (Apex automatically rolls back when there are 
            // unhandled exception, but this is being handled)
            if (!request.doesCallout) {
                Database.rollback(spAllDataChanges);
            }
            
            // Build messages to return.
            String st = ex.getStackTraceString();
            String strEx = ex.getMessage();
            if (st != null) strEx += '\r\nStack Trace:\r\n' + st.trim();
            if (request.debug) System.debug('StackTrace: **' + strEx + '**');

            request.addMessage(ETLC_ApexBridge_Request.MessageType.Errors, strEx);
            if (request.doesCallout) {
                throw new AuraHandledException(strEx);
            }
        }
        
        String output = request.toJSON();
        if (request.debug) System.debug('Output: ' + output);
        return output;
    }
}