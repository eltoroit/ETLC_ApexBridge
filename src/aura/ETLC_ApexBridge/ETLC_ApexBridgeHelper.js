({
    callServer : function(component, helper, params) {
        var startTime, endTime;
        var request = params.request;
        var sourceComponent = params.component;
        var callBackMethod = params.callBackMethod;
        var pleaseWaitInput = params.pleaseWait;
        var forceRefresh = helper.getForceRefresh(component, params.forceRefresh);
        
        // Configure PleaseWait
        var pleaseWait = {
            type: 'Full',
            component: component,
            input: pleaseWaitInput
        }
        if (pleaseWaitInput) {
            if (pleaseWaitInput.type.toUpperCase() === "NONE") {
                pleaseWait.type = 'None';
            } else {
                pleaseWait.message = pleaseWaitInput.message;
                if (pleaseWaitInput.type.toUpperCase() === "TOAST") {
                    pleaseWait.type = 'Toast';
                } else if (pleaseWaitInput.type.toUpperCase() === "FULL") {
                    pleaseWait.type = 'Full';
                } else if (pleaseWaitInput.type.toUpperCase() === "EVENT") {
                    pleaseWait.type = 'Event';
                }           
            }
        }
        helper.pleaseWaitProcess(component, helper, true, pleaseWait);
        
        // Set call
        var action = component.get("c.execute");
        var serverRequest = {
            controller: request.controller,
            method: request.method,
            input: JSON.stringify(request.input),
            debug: component.get("v.debugServer"),
            records: request.records,
            doesCallout: (!request.doesCallout) ? false : true
        }
        action.setParams({dataJson: JSON.stringify(serverRequest)});
        
        // Force refresh?
        if (forceRefresh) {
            action.setStorable({"ignoreExisting": "true"});
        } else if (component.get("v.debugClient")) {
            console.log('Getting ready to call Apex. ', {
                request: request,
                action: action
            });
            action.setStorable({"ignoreExisting": "true"});
        } else {
            action.setStorable();
        }
        
        startTime = new Date();
        action.setCallback(this, function(response) {
            endTime = new Date();
            
            // Process returned data
            var strServerResponse = response.getReturnValue();
            var serverResponse = JSON.parse(strServerResponse);
            serverResponse.state = response.getState();
            serverResponse.time = endTime - startTime;
            serverResponse.json = strServerResponse;
            serverResponse.input = JSON.parse(serverResponse.input);
            serverResponse.output = JSON.parse(serverResponse.output);
            serverResponse.params = params;
            
            // Display serverResponse if doing a debug on client
            if (component.get("v.debugClient")) {
                console.log('Back from Apex (will process response). ', serverResponse);
            }
            
            // Check if 
            if (sourceComponent.isValid()) {
                if (serverResponse.state === "SUCCESS") {
                    if (serverResponse.isSuccess) {
                        if (component.get("v.debugClient")) {
                            console.log('Back from Apex (returning to caller). ', serverResponse);
                        }
                        callBackMethod.call(this, serverResponse);
                    } else {
                        msg = '\r\n*** SERVER ERROR #01 (Operation Not succesful)***\r\n';
                        for (var errorType in serverResponse.messages) {
                            if(serverResponse.messages.hasOwnProperty(errorType)) {
                                msg += errorType + ': ' + serverResponse.messages[errorType].toString();
                            }
                        }
                        if (component.get("v.debugClient")) {
                            console.error(msg);
                            debugger;
                        }
                        helper.pleaseWaitProcess(component, helper, false, pleaseWait);
                        helper.handleError(component, serverResponse, msg);
                    }
                } else {
                    var errors = response.getError();
                    if (component.get("v.debugClient")) {
                        console.error(errors);
                        debugger;
                    }
                    if (errors && errors[0] && errors[0].message) {
                        msg = "\r\n*** SERVER ERROR #02 (State not succesful)***\r\nError message: " + errors[0].message;
                        console.error(msg);
                        helper.pleaseWaitProcess(component, helper, false, pleaseWait);
                        helper.handleError(component, serverResponse, msg);
                    } else {
                        msg = "\r\n*** SERVER ERROR #03 (State not succesful)***\r\nUnknown error)";
                        console.error(msg);
                        helper.pleaseWaitProcess(component, helper, false, pleaseWait);
                        helper.handleError(component, serverResponse, msg);
                    }
                }
            } else {
                msg = "\r\n*** CLIENT ERROR #01 ***\r\nComponent is no longer valid!";
                if (component.get("v.debugClient")) {
                    console.error(msg);
                    debugger;
                }
                helper.pleaseWaitProcess(component, helper, false, pleaseWait);
                helper.handleError(component, serverResponse, msg);
            }
            helper.pleaseWaitProcess(component, helper, false, pleaseWait);
        });
        $A.enqueueAction(action);
    },
    makeRecords : function(data) {
        var type = data.sObjectType;
        var record = data.record;
        var records = data.records;
        
        if (record && records) {
            alert("ETLC_ApexBridge should receive the 'record' or 'records' to process, but not both");
            return;
        } else if (record) {
            records = [record];
        } else if (records) {
            if (records.length == 0) {
                alert("ETLC_ApexBridge received an empty list of 'records' to process");
                return;
            } else if (records.length == 1) {
                records = [record];
            }
        } else {
            alert("ETLC_ApexBridge should receive either 'record' or 'records' to process");
            return;
        }
        
        var listSObjects = [];
        for (var i = 0; i < records.length; i+=1) {
            var r = records[i];
            r.attributes = {"type": type};
            listSObjects.push(r);
        }
        data.callBackMethod.call(this, listSObjects);
    },
    getForceRefresh : function(component, forceRefreshParam) {
        var forceRefresh = component.get("v.forceRefresh");
        if (!(forceRefreshParam === undefined)) {
            forceRefresh = forceRefreshParam;
        }
        if (forceRefresh === undefined) {
            throw new Error("forceRefresh is not defined!");
        } else {
            if (component.get("v.debugClient")) {
                console.log("forceRefresh: " + forceRefresh);
            }
        }
        return forceRefresh;
    },
    handleError : function(component, serverResponse, errorMsg) {
        var params = serverResponse.params;
        var errorHandler = params.errorHandler;
        if (errorHandler === undefined) {
            throw new Error(errorMsg);
        } else {
            errorHandler.call(this, serverResponse, errorMsg);
        }
    },
    pleaseWaitProcess : function(component, helper, isShow, pleaseWait) {
        if (pleaseWait.type === 'None') {
            return; 
        } else if (pleaseWait.type === 'Event') {
            var evApp = $A.get("e.c:ETLC_PleaseWaitEvent");
            evApp.setParams({
                isShow: isShow,
                message: pleaseWait.message
            });
            evApp.fire();
        } else {
            var cmpPleaseWait = component.get("v.cmpPleaseWait");
            if (isShow) {
                if (cmpPleaseWait) {
                    helper.pleaseWaitMessageShow2(cmpPleaseWait, pleaseWait);
                } else {
                    $A.createComponent(
                        "c:ETLC_PleaseWait",
                        {},
                        function(newCmpPleaseWait, status, errorMessage){
                            if (status === "SUCCESS") {
                                var pleaseWaitDiv = component.find("pleaseWaitDiv");
                                var pleaseWaitDivBody = pleaseWaitDiv.get("v.body");
                                pleaseWaitDivBody.push(newCmpPleaseWait);
                                pleaseWaitDiv.set("v.body", pleaseWaitDivBody);
                                component.set("v.cmpPleaseWait", newCmpPleaseWait);
                                helper.pleaseWaitMessageShow2(newCmpPleaseWait, pleaseWait);
                            } else {
                                throw new Error("Can't display message: " + errorMessage);
                            }
                        }
                    );
                }
            } else {
                cmpPleaseWait.showMessage(false);
            }
        }
    },
    pleaseWaitMessageShow2 : function(cmpPleaseWait, pleaseWait) {
        var isFull = pleaseWait.type === 'Full';
        var message = pleaseWait.message;
        
        cmpPleaseWait.set("v.showFullMessage", isFull);
        if (message) {
            cmpPleaseWait.set("v.useDefaultMessage", false);
            cmpPleaseWait.set("v.customMessage", message);
        } else {
            cmpPleaseWait.set("v.useDefaultMessage", true);
            cmpPleaseWait.set("v.customMessage", null);
        }
        cmpPleaseWait.showMessage(true);
    }
})