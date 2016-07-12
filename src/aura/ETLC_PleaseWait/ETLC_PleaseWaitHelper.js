({
	hidePleaseWait : function(component) {
        var modalWindow = component.find("modalWindow");
        $A.util.addClass(modalWindow, "slds-hide");
        $A.util.removeClass(modalWindow, "slds-show");
	}
})