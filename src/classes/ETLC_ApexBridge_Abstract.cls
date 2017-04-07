public abstract class ETLC_ApexBridge_Abstract {
    public abstract Object handleRequest(ETLC_ApexBridge_Request request);
    
    public void process(ETLC_ApexBridge_Request request) {
        try {
            Object output = handleRequest(request);
            request.output = (output == null ? '""' : ETLC_ApexBridge_Request.encodeData(output));
        } catch (ETLC_ApexBridge_InvalidRequest_Exception exIR) {
            String err = 'Unexpected method received (' + request.method + ')';
            throw new ETLC_Exception(err);
        }
    }
}