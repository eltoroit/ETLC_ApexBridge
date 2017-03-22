({
	areYouThere : function(component) {
		var apexBridge = component.find("ApexBridge");
        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_01",
                method: "areYouThere"
            },
            callBackMethod: function (request) {
                alert(request.output);
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
                }
            },
            callBackMethod: function (request) {
                alert(request.output);
            }
        });
	}
})