({
	showMessage : function(component, event, helper) {
		helper.showMessage(component);
	},
    pleaseWaitEvent : function(component, event, helper) {
        var params = event.getParams();
        if (params.type === 'Event') {
            alert((params.isShow ? "Show: " : "Hide: ") + (params.message ? params.message : "<No Message>"));
        }
    }
})