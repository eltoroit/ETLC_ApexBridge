({
    callApex : function(component, event, helper) {
        var params = event.getParams().arguments;
        if (params && params[0]) {
            helper.callServer(component, helper, params[0]);
        } else {
            throw new Error("No arguments passed!");
        }
    },
    makeRecords : function(component, event, helper) {
		var params = event.getParams().arguments;
        if (params && params.data) {
            helper.makeRecords(params.data);
        } else {
            throw new Error("No arguments passed!");
        }
    }
})