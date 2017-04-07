@isTest
public class ETLC_ApexBridge_BaseTests {
    public void invalidMethodTest(String controller) {
        ETLC_ApexBridge_Request requestOut = testHelper(controller, 'invalidMethod');
    }
    
    public ETLC_ApexBridge_Request testHelper(String controller, String method) {
        return testHelper(controller, method, null);
    }
    
    public ETLC_ApexBridge_Request testHelper(String controller, String method, Map<String, Object> data) {
        ETLC_ApexBridge_Request requestIn = new ETLC_ApexBridge_Request();
        requestIn.controller = controller;
        requestIn.method = method;
        if (data != null) requestIn.input = ETLC_ApexBridge_Request.encodeData(data);
        return testHelper(requestIn);
    }
    
    public ETLC_ApexBridge_Request testHelperRecords(String controller, String method, List<sObject> records) {
        ETLC_ApexBridge_Request requestIn = new ETLC_ApexBridge_Request();
        requestIn.controller = controller;
        requestIn.method = method;
        requestIn.records = records;
        return testHelper(requestIn);
    }

    public ETLC_ApexBridge_Request testHelper(ETLC_ApexBridge_Request requestIn) {
        Test.startTest();
        ETLC_ApexBridge_Request requestOut;
        requestOut = ETLC_ApexBridge_Request.fromJSON(
            ETLC_ApexBridge_Controller.execute(requestIn.toJSON())
        );
        Test.stopTest();
        return requestOut;
    }
}