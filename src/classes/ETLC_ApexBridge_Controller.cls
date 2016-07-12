public class ETLC_ApexBridge_Controller {
    @AuraEnabled
    public static String execute(String dataJson) {
        ETLC_ApexBridge_Data data;
        try {
            data = ETLC_ApexBridge_Data.fromJSON(dataJson);
            ETLC_ApexBridge_Abstract executor = (ETLC_ApexBridge_Abstract) Type.forName(data.operation).newInstance();
            executor.process(data);
        } catch (Exception ex) {
            System.debug('**** Exception ****');
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            
            string strEx = '';
            strEx += ex.getMessage();
            if (ex.getStackTraceString() != null) {
                strEx += '\r\nStack Trace:\r\n' + ex.getStackTraceString();                
            }
			
            data.addMessage(ETLC_ApexBridge_Data.MessageType.Errors, strEx);
            // throw new AuraHandledException(strEx);
        }
        return data.toJSON();
    }
}