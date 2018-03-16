public class ETLC_ApexBridge_Controller {
    @AuraEnabled
    public static String execute(String requestJson) {
        Savepoint spAllDataChanges;
        ETLC_ApexBridge_Request request;
        ETLC_ApexBridge_Response response = new ETLC_ApexBridge_Response();

        try {
            System.debug('Input: ' + requestJson);
            response.requestJson = requestJson;
            request = ETLC_ApexBridge_Request.fromJSON(requestJson);
            if (request.debug) System.debug('Input Processed: ' + request);
            if (!request.doesCallout) {
                // If there are any errors, the data will be reset... so, save a SavePoint
                spAllDataChanges = Database.setSavepoint();
            }
            ETLC_ApexBridge_Abstract executor = (ETLC_ApexBridge_Abstract) Type.forName(request.controller).newInstance();
            executor.process(request, response);
            if (request.debug) System.debug('After: ' + request);
        } catch (Exception ex) {
            // Rollback the data changes (Apex automatically rolls back when there are 
            // unhandled exception, but this is being handled)
            if (!request.doesCallout) {
                Database.rollback(spAllDataChanges);
            }
            
            System.debug('**** Exception ****');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            
            // Build messages to return.
            String strEx = '';
            String st = ex.getStackTraceString();
            strEx += ex.getMessage();
            if (st != null){
                st = st.trim();
                if (st != '()') {
                    strEx += '\r\nStack Trace:\r\n' + ex.getStackTraceString();                
                    if (request.debug) System.debug('StackTrace: **' + ex.getStackTraceString() + '**');
                }
            }
            
            response.addMessage(ETLC_ApexBridge_Response.MessageType.Errors, strEx);
            if (request.doesCallout) {
                throw new AuraHandledException(strEx);
            }
        }
        
        String output = response.toJSON(); 
        if (request.debug) System.debug('Output: ' + output);
        return output;
    }
}