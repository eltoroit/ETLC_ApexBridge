({
    doInit : function(component, event, helper) {
        var messages = [];
        messages.push("Why so serious?");
        messages.push("Are we there yet?");
        messages.push("So, do you come here often?");
        messages.push("Please insert another quarter");
        messages.push("Generating next funny line...");
        messages.push("Sorry, are you waiting for me?");
        messages.push("QUIET !!! I am trying to think here !");
        messages.push("Ouch! Careful where you point that mouse!");
        messages.push("Your time is important to us. Please hold. (yeah, right)");
        messages.push("Please wait… Counting backwards from infinity");
        messages.push("Measuring the cable length to fetch your data…");
        messages.push("Please wait while we recalibrate the internet...");
        messages.push("Hang on a second, I know your data is here somewhere");
        messages.push("Please wait while we program the the flux capacitor");
        messages.push("Please wait, we are moving the satellite into position");
        messages.push("Please wait… and wait… well, at least you're not on hold");
        messages.push("Please enter the square root of 598309209839 to continue.");
        messages.push("I am really sorry, it still needs more work… Almost done…");
        messages.push("Please wait, we're building the buildings as fast as we can");
        messages.push("Please wait… Sorry, but these bits are flowing slowly today");
        messages.push("Sorry my binaries are swapped, busy re-sorting them now....");
        messages.push("Please wait… (actually, it's your only choice, so enjoy it)");
        messages.push("Go get a coffee or something. This is going to take a while.");
        messages.push("Please wait… We're just testing your patience. How we are doing?");
        messages.push("Are you waiting for this app to load? Why didn't you say it before.");
        messages.push("Please wait while the hamster wakes up and starts spinning the wheel");
        messages.push("Sorry, I know this is painful to watch... but I have to process this.");
        messages.push("HELP!, I'm being held hostage, and forced to write these stupid lines!");
        messages.push("Please wait, we are checking the gravitational constant in your location");
        messages.push("Please wait while I finish reconfiguring the coffee machine at the office…");
        messages.push("Please wait while we look for the required pixels to render the next screen");
        messages.push("Please be patient. The program should finish loading in six to eight weeks.");
        messages.push("Please wait, looking for the shovel to put more coil in the server and make it run faster");
        messages.push("The last time I tried this the monkey didn't survive. Let's hope it works better this time.");
        messages.push("Please wait, I am currently paging for the system admin. He must hit the Enter key on the server...");
        messages.push("Sorry, a few bits tried to escape, but we caught them… Please wait while we lecture them not to escape again");
        messages.push("Loading ... Please wait attentively (which is what you agreed to in the Terms and Conditions… Did you read them?)");
        messages.push("Did you know that the printer and the computer were dating and had a USB Thumb drive, but the computer does not want to recognize it?");
        component.set("v.messages", messages);
    },
    showPleaseWait : function(component, event, helper) {
        var messages = component.get("v.messages");
        // var msgIndex = 3; // messages.length - 1; 
        var msgIndex = Math.floor(Math.random() * messages.length);
        var message = messages[msgIndex];
        component.set("v.message", message);
        console.log("Please Wait Message: " + message)
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