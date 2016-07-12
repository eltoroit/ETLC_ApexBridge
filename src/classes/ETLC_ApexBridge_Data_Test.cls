@isTest
public class ETLC_ApexBridge_Data_Test {
    @isTest
    public static void testComplexData() {
        Map<String, String> data = new Map<String, String>{'a'=>'a1','b'=>'b1'};
        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.operation = 'SampleOperation';
        d1.input = ETLC_ApexBridge_Data.encodeData(data);
        d1.output = d1.input;
        d1.debug = true;
        d1.records = new List<Account>();
        String jsonData = d1.toJson();
        ETLC_ApexBridge_Data d2 = ETLC_ApexBridge_Data.fromJSON(jsonData);
        system.assertEquals(data, ETLC_ApexBridge_Data.decodeData(d2.output, Map<String, String>.class));
        System.assertEquals(data.get('a'), (String) d1.getInputValue('a'));
    }
    
    @isTest
    public static void TestMessages() {
        ETLC_ApexBridge_Data d1 = new ETLC_ApexBridge_Data();
        d1.addMessage(ETLC_ApexBridge_Data.MessageType.Information, 'Data was copied over');
        d1.addMessage(ETLC_ApexBridge_Data.MessageType.Errors, 'Testing an error');
    }
}