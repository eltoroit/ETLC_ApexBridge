({
    findContacts : function(component, helper) {
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
    updateContacts : function(component, helper, records) {
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
        
    }
})