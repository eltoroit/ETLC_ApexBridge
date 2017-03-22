public with sharing class ETLC_DEMO_Account extends ETLC_ApexBridge_Abstract {
    public override Object handleRequest(ETLC_ApexBridge_Request request) {
        if (request.method == 'findAccounts') {
            return findAccounts(request);
        } else if (request.method == 'saveAccounts') {
            saveAccounts(request);
            return null;
        }
        throw new ETLC_ApexBridge_InvalidRequest_Exception();
    }
    
    private List<Account> findAccounts(ETLC_ApexBridge_Request request) {
        String SOQL = 'SELECT ID, Name, LastModifiedDate FROM Account ';
        SOQL += 'ORDER BY ' + String.valueOf(request.getInputValue('orderBy')) + ' ';
        SOQL += 'LIMIT ' + Integer.valueOf(request.getInputValue('howMany')) + ' ';
        SOQL += 'OFFSET ' + Integer.valueOf(request.getInputValue('offset')) + ' ';
        List<Account> accounts = ETLC_SecuredDB.query(SOQL);
        return accounts;
    }
    private void saveAccounts(ETLC_ApexBridge_Request request) {
        List<Account> accounts = request.records;
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, accounts);
    }
}