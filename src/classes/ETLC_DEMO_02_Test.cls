@isTest
public class ETLC_DEMO_02_Test {
    static String controller = 'ETLC_DEMO_02';
    static ETLC_ApexBridge_BaseTests base = new ETLC_ApexBridge_BaseTests();
    @isTest public static void invalidMethodTest() { base.invalidMethodTest(controller); }
    
	@isTest
    public static void createMeetingTest() {
        Map<String, Object> data = new Map<String, Object>();
        data.put('demoTopic', 'Create demo for ETLC_ApexBridge');
        data.put('demoDuration', 30);
        data.put('demoWhen', DateTime.now());
        ETLC_ApexBridge_Request requestOut = base.testHelper(controller, 'createMeeting', data);
        Event e1 = (Event) ETLC_ApexBridge_Request.decodeData(requestOut.output, Event.class);
        Event e2 = [SELECT Id, Subject, ActivityDateTime, DurationInMinutes
                    FROM Event WHERE ID = :e1.Id];
        System.assertEquals(data.get('demoTopic'), e1.Subject);
        System.assertEquals(data.get('demoWhen'), e1.ActivityDateTime);
        System.assertEquals(data.get('demoDuration'), e1.DurationInMinutes);
        System.assertEquals(data.get('demoTopic'), e2.Subject);
        System.assertEquals(data.get('demoWhen'), e2.ActivityDateTime);
        System.assertEquals(data.get('demoDuration'), e2.DurationInMinutes);
    }
}