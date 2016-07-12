({
    doInit : function(component, event, helper) {
        var originalContact = component.get("v.contact");
        var originalName = helper.makeKey(originalContact);
        component.set("v.oldName", originalName);
    },
    onNameChange : function(component, event, helper) {
        var oldName = component.get("v.oldName");
        var currentContact = component.get("v.contact");
        var newName = helper.makeKey(currentContact);
        var changed = newName != oldName;
        component.set("v.changed", changed);
        var ev = component.getEvent("contactChanged");
        ev.setParams({contact: currentContact, changed:changed});
        ev.fire();
    }
})