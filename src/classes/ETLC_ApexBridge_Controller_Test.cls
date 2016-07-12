@isTest
public class ETLC_ApexBridge_Controller_Test {
    @isTest
    public static void testBasicData() {
        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'ETLC_ApexBridge_DemoEcho';
        d1.input = 'This is a test';
        d1.debug = true;
        String strD2 = ETLC_ApexBridge_Controller.execute(d1.toJson());
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);
        system.assertEquals(d1.input, d2.output);
    }
    
    @isTest
    public static void testInvalidOperation() {
        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'InvalidClass';
        d1.debug = true;
        String strD2 = ETLC_ApexBridge_Controller.execute(d1.toJson());
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(strD2);
        system.assertEquals(d1.input, d2.output);
    }
}