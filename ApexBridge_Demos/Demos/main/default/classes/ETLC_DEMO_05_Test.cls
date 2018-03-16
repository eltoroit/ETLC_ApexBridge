@isTest
public class ETLC_DEMO_05_Test {
    @isTest public static void invalidMethodTest() { ETLC_ApexBridge_TestHelper.invalidMethodTest('ETLC_DEMO_05'); }
    
    @isTest
    public static void saveAccountsTest() {
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_DEMO_05', 'insertAccounts');

        List<Account> acs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            acs.add(new Account(Name='ELTOROIT #' + i));
        }
        client.request.records = acs;
        ETLC_ApexBridge_Response response = client.validate();
        List<Account> acs2 = (List<Account>) JSON.deserialize(response.output, List<Account>.class);
		System.assertEquals(acs.size(), acs2.size());
    }
}