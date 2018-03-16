@isTest
public class ETLC_ApexBridge_TestHelper {
    public ETLC_ApexBridge_Request request;
    public ETLC_ApexBridge_Response response;

    public List<String> Errors {
        get { return getMessages(ETLC_ApexBridge_Response.MessageType.Errors); }
    }
    public List<String> Warnings {
        get { return getMessages(ETLC_ApexBridge_Response.MessageType.Warnings); }
    }
    public List<String> Information {
        get { return getMessages(ETLC_ApexBridge_Response.MessageType.Information); }
    }

    public static ETLC_ApexBridge_TestHelper factory(String controller, String method) {
        ETLC_ApexBridge_TestHelper client = new ETLC_ApexBridge_TestHelper();
        client.request = new ETLC_ApexBridge_Request(controller, method);
        client.request.debug = true;
        return client;
    }

    public ETLC_ApexBridge_Response validate() {
        System.debug(request);
        
        // Prepare the data to simulate the client calling the controller
        request.debug = true;
        request.input = JSON.serialize(request.inputMap);
        request.inputMap = null;
        System.debug(request);
        String requestJson = request.toJSON();
        
        // Call the controller as the client would do.
        // Test.startTest();
        String responseJson = ETLC_ApexBridge_Controller.execute(requestJson);
        response = ETLC_ApexBridge_Response.fromJSON(responseJson);
        // Test.stopTest();
        
        // Basic asserts
        System.assertEquals(requestJson, response.requestJson);
        return response;
    }

    public static void invalidMethodTest(String controller) {
        invalidMethodTest(controller, null);
    }
    public static void invalidMethodTest(String controller, String method) {
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory(controller, method);
        // client.request.doesCallout = true;
        ETLC_ApexBridge_Response response = client.validate();
		
		System.assertEquals(false, response.isSuccess);       
        System.assertEquals(1, client.Errors.size());
        System.assertEquals('Unexpected "method" received', client.Errors[0]);
    }
    
    private List<String> getMessages(ETLC_ApexBridge_Response.MessageType key) {
        List<String> listMessages;
        Map<ETLC_ApexBridge_Response.MessageType, List<String>> mapMessages;
        if (response != null) {
            if (response.messages != null) {
                mapMessages = response.messages;
                if (mapMessages.containsKey(key)) {
                    listMessages = mapMessages.get(key);
                    return listMessages;
                }
            }
        }
        return null;
    }
}