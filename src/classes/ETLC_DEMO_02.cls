public class ETLC_DEMO_02 extends ETLC_ApexBridge_Abstract {
    public override Object handleRequest(ETLC_ApexBridge_Request request) {
        if (request.method == 'createMeeting') {
            return createMeeting(request);
        }
        throw new ETLC_ApexBridge_InvalidRequest_Exception();
    }
    
    private Event createMeeting(ETLC_ApexBridge_Request request) {
        Event ev = new Event();
        ev.Subject = String.valueOf(request.getInputValue('demoTopic'));
        ev.ActivityDateTime = DateTime.valueOf(request.getInputDateTime('demoWhen'));
        ev.DurationInMinutes = Integer.valueOf(request.getInputValue('demoDuration')); 
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.inserting, ev);
        return ev;
    }
}