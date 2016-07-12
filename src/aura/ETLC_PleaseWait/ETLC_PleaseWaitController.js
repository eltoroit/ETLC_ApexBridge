({
    doInit : function(component, event, helper) {
        var errorList = [];
        errorList.push("Why so serious?");
        errorList.push("Are we there yet?");
        errorList.push("So, do you come here often?");
        errorList.push("Please insert another quarter");
        errorList.push("Generating next funny line...");
        errorList.push("Sorry, are you waiting for me?");
        errorList.push("QUIET !!! I am trying to think here !");
        errorList.push("Ouch! Careful where you point that mouse!");
        errorList.push("Your time is important to us. Please hold. (yeah, right)");
        errorList.push("Please wait… Counting backwards from infinity");
        errorList.push("Measuring the cable length to fetch your data…");
        errorList.push("Please wait while we recalibrate the internet...");
        errorList.push("Hang on a second, I know your data is here somewhere");
        errorList.push("Please wait while we program the the flux capacitor");
        errorList.push("Please wait, we are moving the satellite into position");
        errorList.push("Please wait… and wait… well, at least you're not on hold");
        errorList.push("Please enter the square root of 598309209839 to continue.");
        errorList.push("I am really sorry, it still needs more work… Almost done…");
        errorList.push("Please wait, we're building the buildings as fast as we can");
        errorList.push("Please wait… Sorry, but these bits are flowing slowly today");
        errorList.push("Sorry my binaries are swapped, busy re-sorting them now....");
        errorList.push("Please wait… (actually, it's your only choice, so enjoy it)");
        errorList.push("Go get a coffee or something. This is going to take a while.");
        errorList.push("Please wait… We're just testing your patience. How we are doing?");
        errorList.push("Are you waiting for this app to load? Why didn't you say it before.");
        errorList.push("Please wait while the hamster wakes up and starts spinning the wheel");
        errorList.push("Sorry, I know this is painful to watch... but I have to process this.");
        errorList.push("HELP!, I'm being held hostage, and forced to write these stupid lines!");
        errorList.push("Please wait, we are checking the gravitational constant in your location");
        errorList.push("Please wait while I finish reconfiguring the coffee machine at the office…");
        errorList.push("Please wait while we look for the required pixels to render the next screen");
        errorList.push("Please be patient. The program should finish loading in six to eight weeks.");
        errorList.push("Please wait, looking for the shovel to put more coil in the server and make it run faster");
        errorList.push("The last time I tried this the monkey didn't survive. Let's hope it works better this time.");
        errorList.push("Please wait, I am currently paging for the system admin. He must hit the Enter key on the server...");
        errorList.push("Sorry, a few bits tried to escape, but we caught them… Please wait while we lecture them not to escape again");
        errorList.push("Loading ... Please wait attentively (which is what you agreed to in the Terms and Conditions… Did you read them?)");
        errorList.push("Did you know that the printer and the computer were dating and had a USB Thumb drive, but the computer does not want to recognize it?");
        component.set("v.errorList", errorList);
    },
    showPleaseWait : function(component, event, helper) {
        var errorList = component.get("v.errorList");
        // var errorIndex = 3; // errorList.length - 1; 
        var errorIndex = Math.floor(Math.random() * errorList.length);
        var errorMessage = errorList[errorIndex];
        component.set("v.errorMessage", errorMessage);
        console.log("Please Wait Message: " + errorMessage)
        var modalWindow = component.find("modalWindow");
        $A.util.addClass(modalWindow, "slds-show");
        $A.util.removeClass(modalWindow, "slds-hide");
    },
    hidePleaseWait : function(component, event, helper) {
        helper.hidePleaseWait(component);
    },
    onSystemError : function(component, event, helper) {
        helper.hidePleaseWait(component);
    }
})