public with sharing class ContactsController extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Data data) {
        if (data.debug) System.debug(data);
		// Depending on the mode, determine which operation to perform
        String mode = (String) data.getInputValue('mode');
        if (mode == 'QueryByAccountId') {
            List<Contact> cts = query((ID) data.getInputValue('accountId'));
            data.output = ETLC_ApexBridge_Data.encodeData(cts);
        } else if (mode == 'UpdateChangedContacts') {
            List<Contact> cts = (List<Contact>) data.records;
            ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, cts);
        }
    }
    
    public List<Contact> query(ID accountId) {
        List<Contact> cts = [SELECT ID, FirstName, LastName, LastModifiedDate 
                             FROM Contact
                             WHERE AccountID = :accountId 
                             ORDER BY LastModifiedDate DESC];
        ETLC_SecuredDB.validateQuery(cts);
        return cts;
    }
}