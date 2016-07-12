public class ETLC_ApexBridge_DemoEcho extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Data data) {
        data.output = data.input;
    }
}