public with sharing class ETLC_DEMO_01 extends ETLC_ApexBridge_Abstract {
    public override Object handleRequest(ETLC_ApexBridge_Request request) {
        if (request.method == 'areYouThere') {
            return areYouThere(request);
        } else if (request.method == 'greet') {
            return greet(request);
        }
        throw new ETLC_ApexBridge_InvalidRequest_Exception();
    }
    
    private String areYouThere(ETLC_ApexBridge_Request request) {
        System.debug(request);
        return 'Last time I checked, I was here!';
    }
    
    private String greet(ETLC_ApexBridge_Request request) {
        String personName = String.valueOf(request.getInputValue('personName'));
        return 'Hi ' + personName + ', did you know this message came from Apex?';
    }
}