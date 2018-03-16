({
    doInit : function(component, event, helper) {
        var counter = 0;
        component.set("v.counter", counter);
        helper.createLabels(component);
        helper.calculateTimings(component, true);
        component.set("v.showFullMessage", !$A.get("$Browser.isPhone"));            
    },
    pleaseWaitEvent : function(component, event, helper) {
        var params = event.getParams();
        if ((params.type === "Full") || (params.type === "Toast")) {
            if (params.isShow === true) {
                helper.showMessage(component, event, helper);            
            } else if (params.isShow === false) {
                helper.hideMessage(component, event, helper);
            } else {
                throw new Exception("???");
            }    
        } else if ((params.type === "Event") || (params.type === "None")) {
           // Do nothing
        } else {
            throw new Error("Which type of event? [" + params.type + "]");
        }
    }
})