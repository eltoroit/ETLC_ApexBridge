({
    doInit : function(component, event, helper) {
        var d = new Date();
        d = d.toISOString();
        component.set("v.demoWhen", d);
    },
	createMeeting : function(component, event, helper) {
		helper.createMeeting(component);
	}
})