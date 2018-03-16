@isTest
public class ETLC_DEMO_02_Test { 
    @isTest public static void invalidMethodTest() { ETLC_ApexBridge_TestHelper.invalidMethodTest('ETLC_DEMO_02'); }

    @isTest
    public static void createMeetingTest() {
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_DEMO_02', 'createMeeting');
        client.request.inputMap.put('demoTopic', 'Create demo for ETLC_ApexBridge');
        client.request.inputMap.put('demoDuration', 30);
        client.request.inputMap.put('demoWhen', DateTime.now());
        
        ETLC_ApexBridge_Response response = client.validate();
        
        System.assertEquals(true, response.isSuccess);       
        System.assertEquals(null, client.Errors);

        Event eOutput = (Event) ETLC_ApexBridge_Abstract.decodeData(response.output, Event.class);
        Event eQueried = [SELECT Id, Subject, ActivityDateTime, DurationInMinutes
                    FROM Event WHERE ID = :eOutput.Id];

        System.assertEquals(eQueried.Id, eOutput.Id); 
        System.assertEquals(eQueried.Subject, eOutput.Subject);
        System.assertEquals(eQueried.ActivityDateTime, eOutput.ActivityDateTime);
        System.assertEquals(eQueried.DurationInMinutes, eOutput.DurationInMinutes);
    }
}