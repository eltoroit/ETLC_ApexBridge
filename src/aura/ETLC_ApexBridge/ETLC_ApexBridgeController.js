/*
	This is how you would call this method...
    <c:ETLC_ApexBridge aura:id="ApexBridge" />
    var apexBridge = component.find("ApexBridge");
	apexBridge.callApex({
        component: component, 				// Do not change this.
        request: {
        	controller: "DEMO_01",			// This is the name of the class
            method: "countAccounts",		// This is the name of the operation
            input: {						// You can pass data when needed
            	var1: value1,
                data: value
            },
            doesCallout: false,				// Optionally prevents a transaction (Save Point)
            records: [aRecord],				// Optionally if you want to perform a DML operation on records you can pass them as list of records.
        },
        forceRefresh: false,				// Do you want to force a data refresh?
        pleaseWait: {						// If you are using the PleaseWait component, you can fine tune it
            type: "Toast",					// Possible values: Toast, Full
            message: "Please Wait..."		// Set a special message if you do not want the default values
        },
        callBackMethod: function (request) {
        									// This is the function that will handle the response.
        }
    });
*/
({
    callApex : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params && params[0]) {
            helper.callServer(component, helper, params[0]);
        } else {
            throw new Error("No arguments passed!");
        }
    },
    makeRecords : function(component, event, helper) {
		helper.makeRecords(event.getParams().arguments);
    }
})