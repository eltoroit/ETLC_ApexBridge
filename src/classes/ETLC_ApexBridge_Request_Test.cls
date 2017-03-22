@isTest
public class ETLC_ApexBridge_Request_Test {
    @isTest
    public static void testComplexData() {
        DateTime dttm = DateTime.now();
        Map<String, String> data = new Map<String, String>();
        data.put('a', 'a1');
        data.put('b', 'b1');
        data.put('dt', JSON.serialize(dttm.date()));
        data.put('dttm', JSON.serialize(dttm));
        System.debug(data);
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.controller = 'SampleOperation';
        req1.method = 'SampleMethod';
        req1.input = ETLC_ApexBridge_Request.encodeData(data);
        req1.output = req1.input;
        req1.debug = true;
        req1.records = new List<Account>();
        String jsonRequest = req1.toJson();
        ETLC_ApexBridge_Request req2 = ETLC_ApexBridge_Request.fromJSON(jsonRequest);
        System.debug(req2);
        system.assertEquals(data, ETLC_ApexBridge_Request.decodeData(req2.output, Map<String, String>.class));
        System.assertEquals(data.get('a'), (String) req1.getInputValue('a'));
        System.assertEquals(Datetime.newInstanceGmt(dttm.dateGmt(), dttm.timeGmt()),
                            req1.getInputDateTime('dttm'));
        System.assertEquals(dttm.date(), req1.getInputDate('dt'));
    }
    
    @isTest
    public static void TestMessages() {
        ETLC_ApexBridge_Request req1 = new ETLC_ApexBridge_Request();
        req1.addMessage(ETLC_ApexBridge_Request.MessageType.Warnings, 'Warning');
        req1.addMessage(ETLC_ApexBridge_Request.MessageType.Information, 'Information');
        req1.addMessage(ETLC_ApexBridge_Request.MessageType.Errors, 'Error1');
        req1.addMessage(ETLC_ApexBridge_Request.MessageType.Errors, 'Error2');
        Map<ETLC_ApexBridge_Request.MessageType, List<String>> messages = req1.messages;
        System.assertEquals(3, messages.size());
        System.assertEquals(2, messages.get(ETLC_ApexBridge_Request.MessageType.Errors).size());
    }
}