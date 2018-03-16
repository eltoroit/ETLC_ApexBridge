@isTest
public class ETLC_ApexBridge_Controller_Test {
    @isTest public static void invalidMethodTest() { ETLC_ApexBridge_TestHelper.invalidMethodTest('ETLC_ApexBridge_DemoEcho'); }

    @isTest
    public static void testBasicData() {
        String value = 'This is a test';
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_ApexBridge_DemoEcho', 'echo');
        client.request.inputMap.put('value', value);
        client.request.doesCallout = true;

        ETLC_ApexBridge_Response response = client.validate();
        System.assertEquals('"' + value + '"', response.output);
    }

    @isTest 
    public static void invalidMethodTest2() {
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_ApexBridge_DemoEcho', 'InvalidMethod');
        client.request.doesCallout = true;
        
        try {
            ETLC_ApexBridge_Response response = client.validate();
            System.assert(false, 'I was expecting to fail (1)');
        } catch (AuraHandledException ex1) {
            System.assertEquals('Script-thrown exception', ex1.getMessage());
        } catch (Exception ex2) {
            System.assert(false, 'I was expecting to fail (2)');
        }
    }

    @isTest
    public static void testRequest() {
        Map<String, String> data = new Map<String, String>{'a'=>'a1','b'=>'b1'};

        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_ApexBridge_DemoEcho', 'SampleOperation');
        ETLC_ApexBridge_Request request = client.request;
        request.inputMap = data;
        request.doesCallout = true;
        request.input = ETLC_ApexBridge_Abstract.encodeData(request.inputMap);
        request.inputMap = null;
        request.debug = true;
        request.records = new List<Account>();
        String requestJson = request.toJson();
        ETLC_ApexBridge_Request request2 = ETLC_ApexBridge_Request.fromJSON(requestJson);
        System.assertEquals(data.get('a'), (String) request2.getInputValue('a'));
    }
    
    @isTest
    public static void TestMessages() {
        ETLC_ApexBridge_Response response = new ETLC_ApexBridge_Response();
        response.addMessage(ETLC_ApexBridge_Response.MessageType.Information, 'Data was copied over');
        response.addMessage(ETLC_ApexBridge_Response.MessageType.Errors, 'Testing an error');
    }
}