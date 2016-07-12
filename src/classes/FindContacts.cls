public with sharing class FindContacts extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Data data) {
        if (data.debug) System.debug(data);
        List<Contact> cts = query((ID) data.getInputValue('accountId'));
        data.output = ETLC_ApexBridge_Data.encodeData(cts);
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