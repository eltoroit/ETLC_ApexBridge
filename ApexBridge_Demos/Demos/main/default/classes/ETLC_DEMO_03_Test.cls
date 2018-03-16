@isTest
public class ETLC_DEMO_03_Test {
    @isTest public static void invalidMethodTest() { ETLC_ApexBridge_TestHelper.invalidMethodTest('ETLC_DEMO_03'); }

    @testSetup
    public static void createAccounts() {
        List<Account> acs = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            acs.add(new Account(Name='ELTOROIT #' + i));
        }
        insert acs;
    }

	@isTest
    public static void findAccountsTest() {
        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_DEMO_03', 'findAccounts');
        client.request.inputMap.put('howMany', 5);
        client.request.inputMap.put('offset', 0);
        client.request.inputMap.put('orderBy', 'Name');

        ETLC_ApexBridge_Response response = client.validate();
        List<Account> acs = (List<Account>) JSON.deserialize(response.output, List<Account>.class);
        System.assertEquals(5, acs.size());
		for (Integer i = 0; i < acs.size(); i++) {
            System.assertEquals('ELTOROIT #' + i, acs[i].Name);
        }
    }

    @isTest
    public static void saveAccountsTest() {
        List<Account> acsIn = [SELECT ID, Name FROM Account];

        ETLC_ApexBridge_TestHelper client = ETLC_ApexBridge_TestHelper.factory('ETLC_DEMO_03', 'saveAccounts');
        client.request.records = acsIn;
        ETLC_ApexBridge_Response response = client.validate();
        
        List<Account> acsOut = (List<Account>) JSON.deserialize(response.output, List<Account>.class);        
        System.assertEquals(acsIn.size(), acsOut.size());
    }
}