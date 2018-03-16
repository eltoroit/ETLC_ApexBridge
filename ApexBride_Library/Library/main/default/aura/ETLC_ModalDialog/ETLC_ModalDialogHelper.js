({
	closeDialog : function(component) {
		component.set("v.isVisible", false);
	},
    showDialog : function(component) {
        component.set("v.isVisible", true);
    }
})