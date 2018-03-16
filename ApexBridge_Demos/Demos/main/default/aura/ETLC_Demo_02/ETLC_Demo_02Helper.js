({
	createMeeting : function(component) {
		var apexBridge = component.find("ApexBridge");
        
        // Convert local time to UTC
        // var localWhen = new Date(component.get("v.demoWhen"));
		// var localOffset = localWhen.getTimezoneOffset() * 60 * 1000;          
        // var utcWhen = new Date(localWhen.getTime() + localOffset);

        apexBridge.callApex({
            component: component,
            request: {
                controller: "ETLC_DEMO_02",
                method: "createMeeting",
                input: {
                    demoTopic: component.get("v.demoTopic"),
                    demoWhen: new Date(component.get("v.demoWhen")).toJSON(),
                    demoDuration: component.get("v.demoDuration")
                }
            },
            pleaseWait: {
                type: "Full"
            },
            callBackMethod: function (response) {
                console.log(response);
                var e = response.output;
                alert('The event [' + e.Id + '] will remind you');
            },
            callBackError: function (serverResponse, errorMsg) {
                alert(errorMsg);
            }
        });
	}
})

