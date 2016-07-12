({
    callApex : function(component, event, helper) {
        var params = event.getParam('arguments');
        if (params && params[0]) {
            helper.callServer(component, helper, params[0]);
        } else {
            throw "No arguments passed!";
        }
    }
})