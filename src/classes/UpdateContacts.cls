public with sharing class UpdateContacts extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Data data) {
        if (data.debug) System.debug(data);
        updateContacts((List<Contact>) data.records);
    }
    
    public void updateContacts(List<Contact> cts) {
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, cts);
    }
}