@isTest
public class ETLC_DEMO_01_Test {
    static String controller = 'ETLC_DEMO_01';
    static ETLC_ApexBridge_BaseTests base = new ETLC_ApexBridge_BaseTests();
    @isTest public static void invalidMethodTest() { base.invalidMethodTest(controller); }
    
	@isTest
    public static void areYouThereTest() {
        ETLC_ApexBridge_Request requestOut = base.testHelper(controller, 'areYouThere');
        System.assertEquals('"Last time I checked, I was here!"', requestOut.output);
    }
    
    @isTest
    public static void greetTest() {
        String personName = 'Andres';
        Map<String, String> data = new Map<String, String>();
        data.put('personName', personName);
        ETLC_ApexBridge_Request requestOut = base.testHelper(controller, 'greet', data);
        String expected = '"Hi ' + personName + ', did you know this message came from Apex?"';
        System.assertEquals(expected, requestOut.output);
    }
}