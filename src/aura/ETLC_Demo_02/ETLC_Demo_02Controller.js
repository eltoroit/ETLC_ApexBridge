({
    doInit : function(component, event, helper) {
        component.set("v.demoWhen", new Date());
    },
	createMeeting : function(component, event, helper) {
		helper.createMeeting(component);
	}
})