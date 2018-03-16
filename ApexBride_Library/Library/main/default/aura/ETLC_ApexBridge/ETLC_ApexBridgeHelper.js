({
    callServer : function(component, helper, params) {
        var msgError;
        var startTime, endTime;
        var sourceComponent = params.component;
        var request = params.request;
        var pleaseWait = params.pleaseWait;
        var callBackMethod = params.callBackMethod;
        var callBackError = params.callBackError;
        var forceRefresh = helper.getForceRefresh(component, request);

        // Fire show message event
        var msgText;
        var msgType = "Full";
        if (pleaseWait) {
            if ((pleaseWait.type === "Full") || (pleaseWait.type === "Toast") || (pleaseWait.type === "Event") || (pleaseWait.type === "None")) {
                msgType = pleaseWait.type;
            } else {
                throw new Error("Invalid option for message type");
            }
            if (pleaseWait.message) {
                msgText = pleaseWait.message;
            }
        }
        if (msgType != "None") {
            helper.fireMessageEvent(component, true, msgType, msgText);
        }
        
        var action = component.get("c.execute");
        action.setParams({
            requestJson: JSON.stringify({
                controller: request.controller,
                method: request.method,
                input: JSON.stringify(request.input),
                doesCallout: (request.doesCallout) ? true : false,
                records: request.records,
                debug: component.get("v.debugServer")
            })
        });
        
        if (forceRefresh) {
            action.setStorable({"ignoreExisting": "true"});
        } else if (component.get("v.debugClient")) {
            console.log('Getting ready to call Apex. ', request);
            action.setStorable({"ignoreExisting": "true"});
        } else {
            action.setStorable();
        }

        startTime = new Date();
        action.setCallback(this, function(response) {
            endTime = new Date();
            if (component.get("v.debugClient")) {
                console.log('Back from Apex (will process response). ', {
                    state: response.getState(),
                    returnValueJson: response.getReturnValue(),
                    returnValueObj: JSON.parse(response.getReturnValue()),
                    time: endTime - startTime
                });
            }
            if (sourceComponent.isValid()) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var dataReturned = response.getReturnValue();
                    dataReturned = JSON.parse(dataReturned);
                    if (dataReturned.isSuccess) {
                        dataReturned.input = JSON.parse(dataReturned.requestJson);
                        dataReturned.output = JSON.parse(dataReturned.output);
                        if (component.get("v.debugClient")) {
                            console.log('Back from Apex (returning to caller). ', dataReturned);
                            // debugger;
                        }
                        callBackMethod.call(this, dataReturned);
                    } else {
                        msgError = '\r\n*** SERVER ERROR #01 (Operation Not succesful)***\r\n';
                        for (var errorType in dataReturned.messages) {
                            if(dataReturned.messages.hasOwnProperty(errorType)) {
                                msgError += errorType + ': ' + dataReturned.messages[errorType].toString();
                            }
                        }
                        console.error(msgError);
                        if (component.get("v.debugClient")) {
                            debugger;
                        }
                        if (msgType != "None") {
                            helper.fireMessageEvent(component, false, msgType, msgText);
                        }
                        if (callBackError) {
                            callBackError.call(this, response, msgError);
                        } else {
                            throw new Error(msgError);
                        }
                    }
                } else {
                    var errors = response.getError();
                    console.error(errors);
                    if (component.get("v.debugClient")) {
                        debugger;
                    }
                    if (errors && errors[0] && errors[0].message) {
                        msgError = "\r\n*** SERVER ERROR #02 (State not succesful)***\r\nError message: " + errors[0].message;
                        console.error(msgError);
                        if (msgType != "None") {
                            helper.fireMessageEvent(component, false, msgType, msgText);
                        }
                        if (callBackError) {
                            callBackError.call(this, response, msgError);
                        } else {
                            throw new Error(msgError);
                        }
                    } else {
                        msgError = "\r\n*** SERVER ERROR #03 (State not succesful)***\r\nUnknown error)";
                        console.error(msgError);
                        if (msgType != "None") {
                            helper.fireMessageEvent(component, false, msgType, msgText);
                        }
                        if (callBackError) {
                            callBackError.call(this, response, msgError);
                        } else {
                            throw new Error(msgError);
                        }
                    }
                }
            } else {
                msgError = "\r\n*** CLIENT ERROR #01 ***\r\nComponent is no longer valid!";
                console.error(msgError);

                if (component.get("v.debugClient")) {
                    debugger;
                }
                if (msgType != "None") {
                    helper.fireMessageEvent(component, false, msgType, msgText);
                }
                if (callBackError) {
                    callBackError.call(this, response, msgError);
                } else {
                    throw new Error(msgError);
                }
            }
            if (msgType != "None") {
                helper.fireMessageEvent(component, false, msgType, msgText);
            }
        });
        $A.enqueueAction(action);
    },
    makeRecords : function(data) {
        debugger;
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
    getForceRefresh : function(component, request) {
        if (request.forceRefresh !== undefined) {
            return request.forceRefresh;
        } else {
            var forceRefresh = component.get("v.forceRefresh");
            if (forceRefresh === undefined) {
                debugger;
                throw new ("forceRefresh is not defined!");
            } else {
                console.log("forceRefresh: " + forceRefresh);
            }
            return forceRefresh;
        }
    },
    fireMessageEvent : function(component, isShow, msgType, msgText) {
        var evApp = $A.get("e.c:ETLC_PleaseWaitEvent");
        var params = {
            isShow: isShow
        };
        if (msgType) {
            params.type = msgType;
        };
        if (msgText) {
            params.message = msgText;
        };
        evApp.setParams(params);
        evApp.fire();
    }
})