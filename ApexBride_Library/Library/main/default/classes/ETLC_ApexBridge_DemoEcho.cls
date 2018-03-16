public class ETLC_ApexBridge_DemoEcho extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
        String method = (String) request.method;
        if (method == 'echo') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(request.getInputValue('value'));
        } else {
            throw new ETLC_Exception('Unexpected "method" received');
        }
    }
}