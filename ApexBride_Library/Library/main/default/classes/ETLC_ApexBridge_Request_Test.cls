@isTest
public with sharing class ETLC_ApexBridge_Request_Test {
    @isTest
    public static void testDates() {
        Date today = Date.today();
        String todayJson = JSON.serialize(today);

        ETLC_ApexBridge_Request request = new ETLC_ApexBridge_Request('controller',  'method');
        request.inputMap.put('DT', today);
        request.input = JSON.serialize(request.inputMap);
        Date dt2 = request.getInputDate('DT');
    }
}
