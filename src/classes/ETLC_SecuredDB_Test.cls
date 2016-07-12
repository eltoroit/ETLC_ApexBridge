@isTest
private class ETLC_SecuredDB_Test {
    @TestSetup
    private static void BuildObjects() {
        System.debug('BuildObjects:');
        Account a = newAccount(null);
        insert a;
        
        Contact c = newContact(a.Id, null);
        insert c;
        
        Task t = newTask(a.id, c.Id, null);
        insert t;
        
        c = [SELECT Id, Name, LastName, AssistantName, 
             AccountId, Account.Name, Account.Website,
             (SELECT Id, Subject, Description, ActivityDate, Priority, Status, WhatId, WhoId, AccountId, Account.Name FROM tasks) FROM Contact];
        System.debug('Contact created: ' + c);
        System.debug('Task created: ' + c.tasks);
    }
    
    @isTest
    private static void ValidateQuery1() {
        System.debug('ValidateQuery1:');
        Contact c = [SELECT Id, Name, LastName, AssistantName, AccountId FROM Contact LIMIT 1];
        ETLC_SecuredDB.validateQuery(c);
    }
    
    @isTest
    private static void ValidateQuery2() {
        System.debug('ValidateQuery2:');
        List<Contact> cs = [SELECT Id, Name, LastName, AssistantName, AccountId FROM Contact LIMIT 5];
        ETLC_SecuredDB.validateQuery(cs);
    }
    
    @isTest
    private static void ValidateQuery3() {
        System.debug('ValidateQuery3:');
        Contact contacts = [SELECT Id, Name, LastName, AssistantName, AccountId, 
                            Account.Id, Account.Name, Account.Website, 
                            (SELECT Id, Subject, Description, ActivityDate, Priority, Status,
                             WhatId, WhoId, AccountId, Account.Name, Account.Owner.UserName FROM tasks)
                            FROM Contact 
                            LIMIT 1];
        ETLC_SecuredDB.validateQuery(contacts);
    }
    
    @isTest
    private static void ValidateQuery4() {
        System.debug('ValidateQuery4:');
        List<Contact> contacts = [SELECT Id, Name, LastName, AssistantName, AccountId, 
                                  Account.Id, Account.Name, Account.Website, 
                                  (SELECT Id, Subject, Description, ActivityDate, Priority, Status,
                                   WhatId, WhoId, AccountId, Account.Name, Account.Owner.UserName FROM tasks)
                                  FROM Contact 
                                  WHERE ID in (SELECT ContactID FROM Case) 
                                  LIMIT 5];
        ETLC_SecuredDB.validateQuery(contacts);
    }
    
    @isTest
    private static void Query1() {
        System.debug('Query1:');
        String SOQL = 'SELECT Id, Name, LastName, AssistantName, AccountId FROM Contact LIMIT 5';
        ETLC_SecuredDB.query(SOQL);
    }
    
    @isTest
    private static void Query2() {
        System.debug('Query2:');
        String SOQL = '';
        SOQL += 'SELECT Id, Name, LastName, AssistantName, AccountId, ';
        SOQL += 'Account.Id, Account.Name, Account.Website ';
        SOQL += 'FROM Contact LIMIT 5';
        ETLC_SecuredDB.query(SOQL);
    }
    
    @isTest
    private static void Query3() {
        System.debug('Query3:');
        String SOQL = '';
        SOQL += 'SELECT Id, Name, LastName, AssistantName, AccountId, ';
        SOQL += 'Account.Id, Account.Name, Account.Website, ';
        SOQL += '(SELECT Id, Subject, Description, ActivityDate, Priority, Status, WhatId, WhoId, AccountId, Account.Name FROM tasks) ';
        SOQL += 'FROM Contact ';
        SOQL += 'LIMIT 5';
        ETLC_SecuredDB.query(SOQL);
    }
    
    @isTest
    private static void Query4() {
        System.debug('Query4:');
        String SOQL = '';
        SOQL += 'SELECT Id, Name, LastName, AssistantName, AccountId, ';
        SOQL += 'Account.Id, Account.Name, Account.Website, ';
        SOQL += '(SELECT Id, Subject, Description, ActivityDate, Priority, Status, WhatId, WhoId FROM tasks) ';
        SOQL += 'FROM Contact ';
        SOQL += 'LIMIT 5';
        ETLC_SecuredDB.query(SOQL);
    }
    
    @isTest
    private static void Query5() {
        System.debug('Query5:');
        String SOQL = '';
        SOQL += 'SELECT Id, Name, LastName, AssistantName, AccountId, ';
        SOQL += 'Account.Id, Account.Name, Account.Website, ';
        SOQL += '(SELECT Id, Subject, Description, ActivityDate, Priority, Status, WhatId, WhoId, AccountId, Account.Name, Account.Owner.UserName FROM tasks) ';
        SOQL += 'FROM Contact ';
        SOQL += 'WHERE ID in (SELECT ContactID FROM Case) ';
        SOQL += 'LIMIT 5';
        ETLC_SecuredDB.query(SOQL);
    }
    
    @isTest
    private static void PerformMultipleDML() {
        System.debug('Multiple DML operations:');
        Contact c = [SELECT ID, AccountID FROM Contact LIMIT 1];
        
        List<Task> Tasks = new List<Task>();
        for (Integer i = 0; i < 10; i++) {
            Tasks.add(newTask(c.AccountID, c.ID, i));
        }
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Inserting, Tasks);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, Tasks);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, Tasks[0]);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Upserting, Tasks);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Deleting, Tasks);
    }
    
    @isTest
    private static void UpdatingMultipleObjectTypes() {
        System.debug('Updating Multiple Object Types:');
        List<sObject> records = new List<sObject>();
        records.add([SELECT ID FROM Account]);
        records.add([SELECT ID FROM Contact]);
        records.add([SELECT ID FROM Task]);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Updating, records);
    }
    
    @isTest
    private static void Upserting() {
        System.debug('Upserting:');
        Contact c = [SELECT ID, AccountID FROM Contact LIMIT 1];
        
        List<Task> Tasks = new List<Task>();
        for (Integer i = 0; i < 10; i++) {
            Tasks.add(newTask(c.AccountID, c.ID, i));
        }
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Upserting, Tasks);
        ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Upserting, Tasks);
    }
    
    @isTest
    private static void InvalidDML1() {
        try {
            System.debug('InvalidDML1:');
            List<Task> Tasks = [SELECT Id, Subject, Description, ActivityDate, Priority, Status,
                                WhatId, WhoId, AccountId, Account.Name, Account.Owner.UserName
                                FROM Task LIMIT 5];
            ETLC_SecuredDB.performDML(ETLC_SecuredDB.Operation.Querying, Tasks);            
            System.assert(false, 'Exception was not thrown');
        } catch (ETLC_Exception ex1) {
            String expectedMsg = 'I thought you were doing a DML';
            System.assertEquals(expectedMsg, ex1.getMessage(), 'Not the expected exception message');
            // Good!
        } catch (Exception ex2) {
            System.assert(false, 'Exception thrown but not the expected one');
        }
    }
    
    @isTest
    private static void InvalidDML2() {
        try {
            System.debug('InvalidDML2:');
            List<Task> Tasks = [SELECT Id, Subject, Description, ActivityDate, Priority, Status,
                                WhatId, WhoId, AccountId, Account.Name, Account.Owner.UserName
                                FROM Task LIMIT 5];
            ETLC_SecuredDB.performDML(null, tasks);
            System.assert(false, 'Exception was not thrown');
        } catch (ETLC_Exception ex1) {
            String expectedMsg = 'What operation were you performing?';
            System.assertEquals(expectedMsg, ex1.getMessage(), 'Not the expected exception message');
        } catch (Exception ex2) {
            System.assert(false, 'Exception thrown but not the expected one');
        } 
    }
    
    @isTest
    private static void InvalidSOQL() {
        try {
            System.debug('InvalidSOQL:');
            ETLC_SecuredDB.query(null);
        } catch (NullPointerException ex1) {
            String expectedMsg = 'Argument 1 cannot be null';
            System.assertEquals(expectedMsg, ex1.getMessage(), 'Not the expected exception message');
        } catch (Exception ex2) {
            System.assert(false, 'Exception thrown but not the expected one');
        }
    }
    
    /*
    @isTest
    private static void QueryFailSecurity_1() {
        System.debug('QueryFailSecurity_1: Fails security');
        
        // Find a user
        // TODO: Change this criteria to find a user without FLS access on a task field (description)
        try {
            String userCriteria = 'WHERE CommunityNickname = \'ElToro\'';
            User u = Database.query('SELECT ID, FirstName, LastName, email FROM User ' + userCriteria + ' LIMIT 1');
            
            // Build SOQL
            // TODO: Write a query that uses a task field (description) which is not accessible by the user found above.
            String SOQL = 'SELECT Id, description FROM Task LIMIT 5';
            
            // Make sure user has record access to the contact, so that he can see the task
            // TODO: Comment out if Contact is NOT defined with OWD private
            List<ContactShare> contactShares = new List<ContactShare>();
            for (Contact contactTofind : [SELECT ID FROM Contact]) {
                ContactShare cs = new ContactShare();
                cs.ContactAccessLevel = 'READ';
                cs.ContactId = contactToFind.id;
                cs.UserOrGroupId = u.id;
                contactShares.add(cs);
            }
            insert contactShares;
            
            // Execute query as restricted user
            System.runAs(u) {
                try {
                    ETLC_SecuredDB.query(SOQL);
                    System.assert(false, 'Should have failed with Security exception');
                } catch (ETLC_Exception ex1) {
                    // TODO: If you are checking other field, change the message
                    String expectedMsg = 'FLS on [Task.Description] for [Reading]';
                    System.assertEquals(expectedMsg, ex1.getMessage(), 'Not the expected exception message');
                } catch (Exception ex2) {
                    System.assert(false, 'Exception thrown but not the expected one');
                } 
            }
        } catch (Exception ex) {
            System.debug(ex);
        }
    }
    */
    
    // Create records
    private static Account newAccount(Integer counter) {
        Account a = new Account();
        a.Name = 'ElToroIT Inc.';
        if (counter != null) a.Name += ' #' + counter;
        a.Website = 'http://ElToro.it';
        return a;
    }
    private static Contact newContact(ID AccountID, Integer counter) {
        Contact c = new Contact();
        c.LastName = 'ElToroIT';
        if (counter != null) c.LastName += ' #' + counter;
        c.AccountId = AccountID;
        c.AssistantName = 'ElToroIT';
        return c;
    }
    private static Task newTask(ID AccountID, ID ContactID, Integer counter) {
        Task t = new Task();
        t.ActivityDate = Date.today();
        t.Priority = 'High';
        t.Status = 'In Progress';
        t.WhatId = AccountID;
        t.WhoId = ContactID;
        t.Subject = 'Follow @ElToroIT in @GitHub';
        if (counter != null) t.Subject += ' #' + counter;
        t.Description = '';
        t.Description += 'ElToroIT writes good articles for developers about Salesforce ';
        t.Description += 'on topics like Apex, Visualforce and Lightning Components. ';
        t.Description += 'His blog (http://ElToro.IT) is awesome, and I heard ';
        t.Description += 'he has a twitter account @ElToroIT. ';
        t.Description += 'Do not forget to follow him! ';
        return t;
    }
}