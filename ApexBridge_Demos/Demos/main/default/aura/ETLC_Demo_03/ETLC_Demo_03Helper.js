({
    findAcccounts: function (component, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_03",
                method: "findAccounts",
                input: {
                    howMany: 5,
                    offset: 0,
                    orderBy: 'Name'
                }
            },
            pleaseWait: { type: "Full", message: "Finding accounts, please wait" },
            callBackMethod: function (response) {
                component.set("v.accounts", response.output);
            }
        });
    },
    saveAccounts: function (component, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_03",
                method: "saveAccounts",
                records: component.get("v.accounts")
            },
            pleaseWait: { type: "Toast", message: "Saving accounts, please wait" },
            callBackMethod: function (response) {
                helper.findAcccounts(component, helper);
            }
        });
    }
})