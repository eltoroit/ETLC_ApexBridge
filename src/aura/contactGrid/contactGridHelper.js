({
    findContacts : function(component, helper) {
        // Switch these comments around to see the other behaviour
        // helper.findContactsUniqueController(component, helper);
		helper.findContactsReuseController(component, helper);
    },
    updateContacts : function(component, helper, records) {
        // Switch these comments around to see the other behaviour
        // helper.updateContactsUniqueController(component, helper, records);
        helper.updateContactsReuseController(component, helper, records);
    },
    findContactsUniqueController : function(component, helper) {
        var accountId = component.get("v.accountId");
        var apexBridge = component.find("ApexBridge");
        // apexBridge.set("v.debugClient", true);
        // apexBridge.set("v.debugServer", true);
        apexBridge.callApex({
            component: component, 
            data: {
                operation: "findContacts",
                input: {
                    accountId: accountId
                }
            },
            callBackMethod: function (data) {
                component.set("v.contactsChanged", {});
                component.set("v.contacts", data.output);
            }
        });
    },
    findContactsReuseController : function(component, helper) {
        var accountId = component.get("v.accountId");
        var apexBridge = component.find("ApexBridge");
        // apexBridge.set("v.debugClient", true);
        // apexBridge.set("v.debugServer", true);
        apexBridge.callApex({
            component: component, 
            data: {
                operation: "ContactsController",
                input: {
                    mode: "QueryByAccountId",
                    accountId: accountId
                }
            },
            callBackMethod: function (data) {
                component.set("v.contactsChanged", {});
                component.set("v.contacts", data.output);
            }
        });
    },
    updateContactsUniqueController : function(component, helper, records) {
        var apexBridge = component.find("ApexBridge");
        // apexBridge.set("v.debugClient", true);
        // apexBridge.set("v.debugServer", true);
        apexBridge.callApex({
            component: component, 
            data: {
                operation: "updateContacts",
                records: records
            },
            callBackMethod: function (data) {
                helper.findContacts(component, helper);
                component.find("btnSaveContacts").set("v.disabled", true);
            }
        });
        
    },
    updateContactsReuseController : function(component, helper, records) {
        var apexBridge = component.find("ApexBridge");
        // apexBridge.set("v.debugClient", true);
        // apexBridge.set("v.debugServer", true);
        apexBridge.callApex({
            component: component, 
            data: {
                operation: "ContactsController",
                input: {
                    mode: "UpdateChangedContacts"
                },
                records: records
            },
            callBackMethod: function (data) {
                helper.findContacts(component, helper);
                component.find("btnSaveContacts").set("v.disabled", true);
            }
        });
        
    }
})