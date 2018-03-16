public with sharing class ETLC_DEMO_05 extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
        if (request.method == 'insertAccounts') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(insertAccounts(request));
        } else {
            throw new ETLC_Exception('Unexpected "method" received');
        }
    }
    private List<Account> insertAccounts(ETLC_ApexBridge_Request request) {
        List<Account> accounts = request.records;
        for (Integer i = 0; i < accounts.size(); i++) {
            accounts[i].NumberOfEmployees = 100 + (i * 10);
        }
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Inserting, accounts);
        return accounts;
    }
}