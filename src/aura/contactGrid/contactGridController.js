({
    changeAccountId : function(component, event, helper) {
        helper.findContacts(component, helper); 
    },
    contactChanged : function(component, event, helper) {
        var params = event.getParams();
        var contact = params.contact;
        var changed = params.changed;
        var contactId = contact.Id;
        var contactsChanged = component.get("v.contactsChanged");
        if (changed) {
            contactsChanged[contactId] = contact;
        } else {
            delete contactsChanged[contactId];            
        }
        var hasContactsChanged = Object.keys(contactsChanged).length != 0;
        component.set("v.contactsChanged", contactsChanged);
        component.find("btnSaveContacts").set("v.disabled", !hasContactsChanged); 
        console.log(contactsChanged);
    },
    saveContacts : function(component, event, helper) {
        var records = [];
        
        var contactsChanged = component.get("v.contactsChanged");
        for (var key in contactsChanged){
            if (contactsChanged.hasOwnProperty(key)) {
                records.push(contactsChanged[key]);    
            }
        }
        helper.updateContacts(component, helper, records);
    }
})