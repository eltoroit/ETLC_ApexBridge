({
    doInit : function(component, event, helper) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component, 
            data: {
                operation: "findAccounts"
            },
            callBackMethod: function (data) {
                var accounts = data.output;
                var accountsSize = accounts.length;
                var opts = [];
                if (accountsSize > 0) {
                    opts.push({label:"Please select account", value:null, selected:"true"});
                    for (var i = 0; i < accountsSize; i++) {
                        var account = accounts[i];
                        opts.push({
                            value: account.Id,
                            label: account.Name
                        }); 
                    }
                }
                component.find("accountsList").set("v.options", opts);
            }
        });
    },
    accountSelected : function(component, event, helper) {
        var ev = component.getEvent("accountChanged");
        ev.setParams({
            accountId: component.find("accountsList").get("v.value")
        });
        ev.fire();
    }
})