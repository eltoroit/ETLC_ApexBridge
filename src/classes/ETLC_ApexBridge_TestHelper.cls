/*
This class is used in testing the controller... the class can't be annotated with
@isTest because we need to create an instance of this class *dynamically* at run time.
*/
public class ETLC_ApexBridge_TestHelper extends ETLC_ApexBridge_Abstract {
    public override Object handleRequest(ETLC_ApexBridge_Request request) {
        if (request.method == 'simpleCopy') {
            return simpleCopy(request);
        }
        throw new ETLC_ApexBridge_InvalidRequest_Exception();
    }
    
    private String simpleCopy(ETLC_ApexBridge_Request request) {
        return request.input;
    }
}