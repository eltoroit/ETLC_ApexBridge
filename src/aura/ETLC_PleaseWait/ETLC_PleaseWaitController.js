({
    doInit : function(component, event, helper) {
        var counter = 0;
        component.set("v.counter", counter);
        helper.createLabels(component);
        helper.calculateTimings(component, true);
        component.set("v.showFullMessage", !$A.get("$Browser.isPhone"));            
    },
    showMessage : function(component, event, helper) {
        var params = event.getParams().arguments;
        if (params) {
            if (params.isShow === true) {
                helper.showMessage(component, helper);            
            } else if (params.isShow === false) {
                helper.hideMessage(component, helper);
            } else {
                throw new Exception("Not sure what you are asking for");
            }
        } else {
            throw new Error("No arguments passed!");
        }        
    }
})