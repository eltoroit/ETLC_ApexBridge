public with sharing class ETLC_DEMO_03 extends ETLC_ApexBridge_Abstract {
    public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
        if (request.method == 'findAccounts') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(findAccounts(request));
        } else if (request.method == 'saveAccounts') {
            response.output = ETLC_ApexBridge_Abstract.encodeData(saveAccounts(request));
        } else {
            throw new ETLC_Exception('Unexpected "method" received');
        }
    }

    private List<Account> findAccounts(ETLC_ApexBridge_Request request) {
        String SOQL = 'SELECT ID, Name, LastModifiedDate FROM Account ';
        SOQL += 'ORDER BY ' + String.valueOf(request.getInputValue('orderBy')) + ' ';
        SOQL += 'LIMIT ' + Integer.valueOf(request.getInputValue('howMany')) + ' ';
        SOQL += 'OFFSET ' + Integer.valueOf(request.getInputValue('offset')) + ' ';
        List<Account> accounts = ETLC_SecuredDB.query(SOQL);
        return accounts;
    }

    private List<Account> saveAccounts(ETLC_ApexBridge_Request request) {
        List<Account> accounts = request.records;
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, accounts);
        return accounts;
    }
}