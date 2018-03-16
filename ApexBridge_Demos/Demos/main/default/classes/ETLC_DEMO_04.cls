public with sharing class ETLC_DEMO_04 extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
        if (request.method == 'pleaseWait') {
            pleaseWait(request);
            response.output = null;
        } else {
            throw new ETLC_Exception('Unexpected "method" received');
        }
    }
    
    private void pleaseWait(ETLC_ApexBridge_Request request) {
        System.debug(request);
    }
}