({
    findAcccounts : function(component, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_Account",
                method: "findAccounts",
                input: { howMany: 5, offset: 0, orderBy: 'Name' }
            },
	        pleaseWait: { type: "Full", message: "Finding accounts, please wait" },
            callBackMethod: function (request) {
               component.set("v.accounts", request.output);
            }
        });
    },
    saveAccounts : function(component, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_Account",
                method: "saveAccounts",
                records: component.get("v.accounts")
            },
            pleaseWait: { type: "Full", message: "Saving accounts, please wait" },
            callBackMethod: function(request) {
                helper.findAcccounts(component, helper);
            }
        });
    }
})