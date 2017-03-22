@isTest
public class ETLC_DEMO_Account_Test {
    static String controller = 'ETLC_DEMO_Account';
    static ETLC_ApexBridge_BaseTests base = new ETLC_ApexBridge_BaseTests();
    @isTest public static void invalidMethodTest() { base.invalidMethodTest(controller); }
    
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
        Map<String, Object> data = new Map<String, Object>();
        data.put('howMany', 5);
        data.put('offset', 0);
        data.put('orderBy', 'Name');
        ETLC_ApexBridge_Request requestOut = base.testHelper(controller, 'findAccounts', data);
        List<Account> acs = (List<Account>) JSON.deserialize(requestOut.output, List<Account>.class);
        System.assertEquals(5, acs.size());
		for (Integer i = 0; i < acs.size(); i++) {
            System.assertEquals('ELTOROIT #' + i, acs[i].Name);
        }
    }
    
    @isTest
    public static void saveAccountsTest() {
        List<Account> acs = [SELECT ID, Name FROM Account];
        ETLC_ApexBridge_Request requestOut = base.testHelperRecords(controller, 'saveAccounts', acs);
        System.assertEquals('""', requestOut.output);
    }
}