({
    callServer : function(component, helper, params) {
        var startTime, endTime;
        var data = params.data;
        var sourceComponent = params.component;
        var callBackMethod = params.callBackMethod;
        
        var action = component.get("c.execute");
        action.setParams({
            dataJson: JSON.stringify({
                operation: data.operation,
                input: JSON.stringify(data.input),
                debug: component.get("v.debugServer"),
                records: data.records
            })
        });
        if (component.get("v.debugClient")) {
            console.log('Getting ready to call Apex. ', {
                data: data,
                action: action
            });
        } else {
            // Cache requests for 1 minutes
            action.setStorable({"refresh":60*1});
        }
        startTime = new Date();
        action.setCallback(this, function(response) {
            endTime = new Date();
            if (component.get("v.debugClient")) {
                console.log('Back from Apex. ', {
                    response: response,
                    time: endTime - startTime
                });
            }
            if (sourceComponent.isValid()) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var dataReturned = response.getReturnValue();
                    dataReturned = JSON.parse(dataReturned);
                    if (dataReturned.isSuccess) {
                        dataReturned.input = JSON.parse(dataReturned.input);
                        dataReturned.output = JSON.parse(dataReturned.output);
                        if (component.get("v.debugClient")) {
                            console.log('Back from Apex. ', dataReturned);
                            debugger;
                        }
                        callBackMethod.call(this, dataReturned);
                    } else {
                        var msg = '\r\n*** SERVER ERROR #01 (Operation Not succesful)***\r\n';
                        for (var errorType in dataReturned.messages) {
                            msg += errorType + ': ' + dataReturned.messages[errorType].toString();
                        }
                        console.error(msg);
                        if (component.get("v.debugClient")) {
                            debugger;
                        }
                        throw new Error(msg);
                    }
                } else {
                    var errors = response.getError();
                    console.error(errors);
                    if (component.get("v.debugClient")) {
                        debugger;
                    }
                    if (errors && errors[0] && errors[0].message) {
                        var msg = "\r\n*** SERVER ERROR #02 (State not succesful)***\r\nError message: " + errors[0].message;
                        console.error(msg);
                        throw new Error(msg);
                    } else {
                        var msg = "\r\n*** SERVER ERROR #03 (State not succesful)***\r\nUnknown error)";
                        console.error(msg);
                        throw new Error(msg);
                    }
                }        
            } else {
                var msg = "\r\n*** CLIENT ERROR #01 ***\r\nComponent is no longer valid!";
                console.error(msg);
                
                if (component.get("v.debugClient")) {
                    debugger;
                }
                throw new Error(msg);
            }
        });
        $A.enqueueAction(action);
    }
})