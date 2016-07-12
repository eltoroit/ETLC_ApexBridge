@isTest
public class FindContacts_Test {
	@isTest
    public static void findContacts() {
        // Create records to be found
        Account a = new Account(Name='TestAccount');
        insert a;
        List<Contact> cs = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            cs.add(new Contact(LastName='Contact#'+i,accountId=a.id));
        }
        insert cs;
        
        // Prepare the data to simulate the client calling the controller
        Map<String, String> input = new Map<String, String>();
        input.put('accountId', a.Id);
        
        // Call client
        ETLC_ApexBridge_ClientTestHelper tester = new ETLC_ApexBridge_ClientTestHelper();
        tester.operation = 'FindContacts';
        tester.input = input;
		String dataJson = tester.validate();

		// Validate
        List<sObject> records = (List<sObject>) JSON.deserialize(dataJson, List<sObject>.class);
        System.assertEquals(10, records.size());
    }
}