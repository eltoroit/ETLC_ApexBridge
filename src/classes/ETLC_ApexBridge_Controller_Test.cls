@isTest
public class ETLC_ApexBridge_Controller_Test {
    static ETLC_ApexBridge_BaseTests base = new ETLC_ApexBridge_BaseTests();
    
    @isTest
    public static void testValidData() {
        ETLC_ApexBridge_Request requestIn = new ETLC_ApexBridge_Request();
        requestIn.controller = 'ETLC_ApexBridge_TestHelper';
        requestIn.method = 'simpleCopy';
        requestIn.input = 'This is a test';
        ETLC_ApexBridge_Request requestOut = base.testHelper(requestIn);

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
        base.testHelper(req1);
    }

    @isTest
    public static void testInvalid02() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'InvalidClass';
        req1.method = null;
        base.testHelper(req1);
    }
    
    @isTest
    public static void testInvalid03() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'InvalidClass';
        req1.method = 'InvalidMethod';
        req1.doesCallout = true;
        try {
            base.testHelper(req1);
        } catch (Exception ex) {
            System.debug(ex);
        }
    }
    
    @isTest
    public static void testInvalid04() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'ETLC_ApexBridge_TestHelper';
        req1.method = 'InvalidMethod';
        base.testHelper(req1);
    }
}