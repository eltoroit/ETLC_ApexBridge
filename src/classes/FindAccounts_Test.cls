@isTest
public class FindAccounts_Test {
	@isTest
    public static void FindAccounts() {
        // Create records to be found
        List<Account> acts = new List<Account>();
        for (Integer i = 0; i < 10; i++) {
            acts.add(new Account(Name='Account#'+i));
        }
        insert acts;
        
        // Call client
        ETLC_ApexBridge_ClientTestHelper tester = new ETLC_ApexBridge_ClientTestHelper();
        tester.operation = 'FindAccounts';
		String dataJson = tester.validate();

		// Validate
        List<sObject> records = (List<sObject>) JSON.deserialize(dataJson, List<sObject>.class);
        System.assertEquals(10, records.size());
    }
}