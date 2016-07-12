public with sharing class FindAccounts extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Data data) {
        List<Account> acts = query();
        data.output = ETLC_ApexBridge_Data.encodeData(acts);
    }
    
    public List<Account> query() {
        List<Account> acts = [SELECT ID, Name
                              FROM Account
                              ORDER BY Name];
        ETLC_SecuredDB.validateQuery(acts);
        return acts;
    }
}