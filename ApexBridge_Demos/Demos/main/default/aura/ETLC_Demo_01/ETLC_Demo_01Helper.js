({
    areYouThere : function(component) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_01",
                method: "areYouThere"
            },
            callBackMethod: function (response) {
                alert(response.output);
            }
        });
    },
    greet : function(component) {
        var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_01",
                method: "greet",
                input: {
                    personName: component.get("v.yourName")
                },
                forceRefresh: false,
                doesCallout: false
            },
            pleaseWait: {
                type: "Full"
            },
            callBackMethod: function (response) {
                alert(response.output);
            }
        });
    }
})