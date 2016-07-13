@isTest
public class ContactsController_Test {
    @testSetup
    public static void createRecords() {
        // Create records to be found.
        Account a = new Account(Name='TestAccount');
        insert a;
        List<Contact> cs = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            cs.add(new Contact(LastName='Contact#'+i,accountId=a.id));
        }
        insert cs;
    }
    
	@isTest
    public static void findContacts() {
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        List<Contact> cs = [SELECT id, LastName, accountId FROM Contact];
        
        // Prepare the data to simulate the client calling the controller
        Map<String, String> input = new Map<String, String>();
        input.put('mode', 'QueryByAccountId');
        input.put('accountId', a.Id);
        
        // Call client
        ETLC_ApexBridge_ClientTestHelper tester = new ETLC_ApexBridge_ClientTestHelper();
        tester.operation = 'ContactsController';
        tester.input = input;
		String dataJson = tester.validate();

		// Validate
        List<sObject> records = (List<sObject>) JSON.deserialize(dataJson, List<sObject>.class);
        System.assertEquals(10, records.size());
    }
    
    @isTest
    public static void updateContacts() {
        Account a = [SELECT Id, Name FROM Account LIMIT 1];
        List<Contact> cs = [SELECT id, LastName, accountId FROM Contact];
        for (Contact c : cs) {
            c.LastName += ' (Updated)';
        }
        
        // Prepare the data to simulate the client calling the controller
        Map<String, String> input = new Map<String, String>();
        input.put('mode', 'UpdateChangedContacts');
        
        // Call client
        ETLC_ApexBridge_ClientTestHelper tester = new ETLC_ApexBridge_ClientTestHelper();
        tester.operation = 'ContactsController';
        tester.input = input;
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