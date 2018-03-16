/*
lightning:notificationsLibrary does not now for custom app.
https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/ref_lightning_notificationsLibrary.htm
*/
({
	closeDialog : function(component, event, helper) {
        helper.closeDialog(component);
	},
    showDialog : function(component, event, helper) {
        helper.showDialog(component);
    }
})