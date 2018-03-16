({
    showMessage: function (component, event, helper) {
        var counter = component.get("v.counter") + 1;
        component.set("v.counter", counter);
        if (counter >= 1) {
            // Initialize variables
            var isFull = true;
            var isPhone = $A.get("$Browser.isPhone");
            var params = event.getParams();
            if (isPhone) isFull = false;
            if (params.type === "Toast") isFull = false;

            helper.calculateTimings(component, true);
            component.set("v.isMessageShown", true);
            component.set("v.showFullMessage", isFull);

            if (params.message) {
                component.set("v.message", params.message);
                component.set("v.usedSeconds", component.get("v.maxSeconds") * 2);
            }

            // Show message
            if ((isFull) || (params.type === "Toast")) {
                if (params.type === "Toast") {
                    var toastEvent = $A.get("e.force:showToast");
                    if (toastEvent) {
                        toastEvent.setParams({
                            "title": "Please Wait",
                            "message": component.get("v.message")
                        });
                        toastEvent.fire();
                    } else {
                        console.log("No toast event becaouse not in one/one.app");
                        isFull = true;
                        component.set("v.showFullMessage", isFull);
                    }
                }
                if (isFull) {
                    var modalWindow = component.find("msgWindow");
                    $A.util.addClass(modalWindow, "slds-show");
                    $A.util.removeClass(modalWindow, "slds-hide");

                    // If the modal window was scheduled to be hidden,
                    // stop the timer.
                    var timer = component.get("v.timer");
                    if (timer) {
                        window.clearTimeout(timer);
                    }
                }
            } else {
                alert("What type of message? [" + params.type + "]")
            }
        }
    },
    hideMessage: function (component, event, helper) {
        // window.clearTimeout(component.get("v.timer"));
        var counter = component.get("v.counter") - 1;
        component.set("v.counter", counter);
        if (counter <= 0) {
            var timer = window.setTimeout(
                $A.getCallback(function () {
                    helper.calculateTimings(component, false);
                    component.set("v.isMessageShown", false);
                    var modalWindow = component.find("msgWindow");
                    $A.util.addClass(modalWindow, "slds-hide");
                    $A.util.removeClass(modalWindow, "slds-show");
                }), 1000);
            component.set("v.timer", timer);
        }
    },
    createLabels: function (component) {
        var formFactor = $A.get("$Browser.formFactor");
        var messages = [];

        messages.push("Why so serious?");
        messages.push("Are we there yet?");
        messages.push("So, do you come here often?");
        messages.push("Please insert another quarter");
        messages.push("Generating next funny line...");
        messages.push("Sorry, are you waiting for me?");

        if ((formFactor == "TABLET") || (formFactor == "DESKTOP")) {
            messages.push("QUIET!!! I am trying to think here!");
            messages.push("Ouch! Careful where you point that mouse!");
            messages.push("Your time is important to us. Please hold.");
            messages.push("Please wait… Counting backwards from infinity");
            messages.push("Measuring the cable length to fetch your data…");
            messages.push("Please wait while we recalibrate the internet...");
            messages.push("Hang on a second, I know your data is here somewhere");
            messages.push("Please wait while we program the flux capacitor");
            messages.push("Please wait, we are moving the satellite into position");
            messages.push("Please wait… and wait… well, at least you're not on hold");
            messages.push("Please enter the square root of 598309209839 to continue.");
            messages.push("I am really sorry, it still needs more work… Almost done…");
            messages.push("Please wait, we're building the buildings as fast as we can");
            messages.push("Please wait… Sorry, but these bits are flowing slowly today");
            messages.push("Sorry my binaries are swapped, busy re-sorting them now....");
            messages.push("Please wait… (actually, it's your only choice, so enjoy it)");
            messages.push("Go get a coffee or something. This is going to take a while.");
        }

        if (formFactor == "DESKTOP") {
            messages.push("Please wait… We're just testing your patience. How we are doing?");
            messages.push("Are you waiting for this app to load? Why didn't you say so before.");
            messages.push("Please wait while the hamster wakes up and starts spinning the wheel");
            messages.push("Sorry, I know this is painful to watch... but I have to process this.");
            messages.push("HELP! I'm being held hostage and forced to write these corny lines!");
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
        }

        component.set("v.messages", messages);
        component.set("v.usedSeconds", 2 * component.get("v.maxSeconds"));
    },
    calculateTimings: function (component, isON) {
        var now, message, messages, msgIndex;
        var maxSeconds = component.get("v.maxSeconds");
        var usedSeconds = component.get("v.usedSeconds");
        var usedStarted = component.get("v.usedStarted");

        if (isON) {
            if (usedSeconds > maxSeconds) {
                // Change message
                messages = component.get("v.messages");
                msgIndex = Math.floor(Math.random() * messages.length);
                message = messages[msgIndex];
                component.set("v.usedSeconds", 0);
                component.set("v.message", message);
                component.set("v.usedStarted", new Date());
            } else {
                // Update timings
                now = new Date();
                usedSeconds = (now - usedStarted) / 1000;
                component.set("v.usedSeconds", usedSeconds);
            }
        }
    }
})