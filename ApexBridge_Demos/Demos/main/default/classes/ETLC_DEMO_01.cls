public with sharing class ETLC_DEMO_01 extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
        if (request.method == 'areYouThere') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(areYouThere(request));
        } else if (request.method == 'greet') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(greet(request));
        } else {
            throw new ETLC_Exception('Unexpected "method" received');
        }
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