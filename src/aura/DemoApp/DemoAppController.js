({
	accountChanged : function(component, event, helper) {
        var accountId = event.getParam("accountId");
        component.set("v.accountSelected", accountId);
	}
})