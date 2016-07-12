@isTest
public class UpdateContacts_Test {
	@isTest
    public static void UpdateContacts() {
        // Create records to be found
        Account a = new Account(Name='TestAccount');
        insert a;
        List<Contact> cs = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            cs.add(new Contact(LastName='Contact#'+i,accountId=a.id));
        }
        insert cs;
        for (Contact c : cs) {
            c.LastName += ' (Updated)';
        }
        
        
        // Call client
        ETLC_ApexBridge_ClientTestHelper tester = new ETLC_ApexBridge_ClientTestHelper();
        tester.operation = 'UpdateContacts';
        tester.records = cs;
		String dataJson = tester.validate();

		// Validate
        System.assertEquals(null, dataJson);
		for (Contact c : [SELECT ID, LastName, AccountID FROM contact]) {
            String name = c.LastName;
            System.assertEquals(a.id, c.AccountId);
            System.assert(name.contains('(Updated)'));
        }
    }
}