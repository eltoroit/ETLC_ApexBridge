@isTest
public class ETLC_ApexBridge_Controller_Test {
    @isTest
    public static void testValidData() {
        ETLC_ApexBridge_Request requestIn = new ETLC_ApexBridge_Request();
        requestIn.controller = 'ETLC_ApexBridge_TestHelper';
        requestIn.method = 'simpleCopy';
        requestIn.input = 'This is a test';
        ETLC_ApexBridge_Request requestOut = testHelper(requestIn);

        // Basic asserts
        System.assertEquals(requestIn.input, requestOut.input);
        System.assertEquals(requestIn.controller, requestOut.controller);
        System.assertEquals(requestIn.method, requestOut.method);

        // Assert data
        System.assertEquals('"' + requestIn.input + '"', requestOut.output);
    }
    
    @isTest
    public static void testInvalid01() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = null;
        testHelper(req1);
    }

    @isTest
    public static void testInvalid02() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'InvalidClass';
        req1.method = null;
        testHelper(req1);
    }
    
    @isTest
    public static void testInvalid03() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'InvalidClass';
        req1.method = 'InvalidMethod';
        req1.doesCallout = true;
        try {
            testHelper(req1);
        } catch (Exception ex) {
            System.debug(ex);
        }
    }
    
    @isTest
    public static void testInvalid04() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'ETLC_ApexBridge_TestHelper';
        req1.method = 'InvalidMethod';
        testHelper(req1);
    }
    
    private static ETLC_ApexBridge_Request testHelper(ETLC_ApexBridge_Request req1) {
        Test.startTest();
        ETLC_ApexBridge_Request req2;
        req2 = ETLC_ApexBridge_Request.fromJSON(
            ETLC_ApexBridge_Controller.execute(req1.toJson())
        );
        Test.stopTest();
        return req2;
    }
}