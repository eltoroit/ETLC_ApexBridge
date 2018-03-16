public with sharing class ETLC_DEMO_02 extends ETLC_ApexBridge_Abstract { 
    public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
        if (request.method == 'createMeeting') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(createMeeting(request));
        } else {
            throw new ETLC_Exception('Unexpected "method" received');
        }
    }
    
    private Event createMeeting(ETLC_ApexBridge_Request request) {
        Event ev = new Event();
        ev.Subject = String.valueOf(request.getInputValue('demoTopic'));
        ev.ActivityDateTime = DateTime.valueOf(request.getInputDateTime('demoWhen'));
        ev.DurationInMinutes = Integer.valueOf(request.getInputValue('demoDuration')); 
        ev.IsAllDayEvent = ev.DurationInMinutes >= (24*60);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.inserting, ev);
        return ev;
    }
}