@isTest
public class ETLC_DEMO_01_Test {
    @isTest public static void invalidMethodTest() { ETLC_ApexBridge_TestHelper.invalidMethodTest('ETLC_DEMO_01'); }

    @isTest
    public static void areYouThereTest() {
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_DEMO_01', 'areYouThere');
        ETLC_ApexBridge_Response response = client.validate();
        
        System.assertEquals(true, response.isSuccess);       
        System.assertEquals(null, client.Errors);
        System.assertEquals('"Last time I checked, I was here!"', response.output);
    }

    @isTest
    public static void greetTest() {
        String personName = 'Andres';
        String expected = '"Hi ' + personName + ', did you know this message came from Apex?"';
        
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_DEMO_01', 'greet');
        client.request.inputMap.put('personName', personName);
        ETLC_ApexBridge_Response response = client.validate();
        
        System.assertEquals(true, response.isSuccess);       
        System.assertEquals(null, client.Errors);
        System.assertEquals(expected, response.output);
    }
}