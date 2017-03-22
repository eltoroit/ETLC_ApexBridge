({
    callServer : function(component, helper, params) {
        var msg;
        var startTime, endTime;
        var request = params.request;
        var sourceComponent = params.component;
        var callBackMethod = params.callBackMethod;
        var pleaseWait = params.pleaseWait;
        var forceRefresh = helper.getForceRefresh(component, params.forceRefresh);
        
        // Fire show message event
        var msg;
        var msgType = "Full";
        if (pleaseWait) {
            if (pleaseWait.type === "Full") {
                msgType = pleaseWait.type;
            } else if (pleaseWait.type === "Toast") {
                msgType = pleaseWait.type;
            } else {
                throw new Error("Invalid option for message type");
            }
            if (pleaseWait.message) {
                msg = pleaseWait.message;
            }
        }
        helper.fireMessageEvent(component, true, msg, msgType);
        
        var action = component.get("c.execute");
        action.setParams({
            dataJson: JSON.stringify({
                controller: request.controller,
                method: request.method,
                input: JSON.stringify(request.input),
                debug: component.get("v.debugServer"),
                records: request.records,
                doesCallout: (!request.doesCallout) ? false : true
            })
        });
        
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
                        dataReturned.input = JSON.parse(dataReturned.input);
                        dataReturned.output = JSON.parse(dataReturned.output);
                        if (component.get("v.debugClient")) {
                            console.log('Back from Apex (returning to caller). ', dataReturned);
                            // debugger;
                        }
                        callBackMethod.call(this, dataReturned);
                    } else {
                        msg = '\r\n*** SERVER ERROR #01 (Operation Not succesful)***\r\n';
                        for (var errorType in dataReturned.messages) {
                            if(dataReturned.messages.hasOwnProperty(errorType)) {
                                msg += errorType + ': ' + dataReturned.messages[errorType].toString();
                            }
                        }
                        console.error(msg);
                        if (component.get("v.debugClient")) {
                            debugger;
                        }
                        helper.fireMessageEvent(component, false);
                        throw new Error(msg);
                    }
                } else {
                    var errors = response.getError();
                    console.error(errors);
                    if (component.get("v.debugClient")) {
                        debugger;
                    }
                    if (errors && errors[0] && errors[0].message) {
                        msg = "\r\n*** SERVER ERROR #02 (State not succesful)***\r\nError message: " + errors[0].message;
                        console.error(msg);
                        helper.fireMessageEvent(component, false);
                        throw new Error(msg);
                    } else {
                        msg = "\r\n*** SERVER ERROR #03 (State not succesful)***\r\nUnknown error)";
                        console.error(msg);
                        helper.fireMessageEvent(component, false);
                        throw new Error(msg);
                    }
                }
            } else {
                msg = "\r\n*** CLIENT ERROR #01 ***\r\nComponent is no longer valid!";
                console.error(msg);
                
                if (component.get("v.debugClient")) {
                    debugger;
                }
                helper.fireMessageEvent(component, false);
                throw new Error(msg);
            }
            helper.fireMessageEvent(component, false);
        });
        $A.enqueueAction(action);
    },
    makeRecords : function(data) {
        var type = data.type;
        var record = data.record;
        var records = data.records;
        var isOneRecord;
        
        if (record && records) {
            alert("ETLC_ApexBridge should receive the 'record' or 'records' to process, but not both");
            return;
        } else if (record) {
            records = [record];
            isOneRecord = true;
        } else if (records) {
            if (records.length == 0) {
                alert("ETLC_ApexBridge received an empty list of 'records' to process");
                return;
            } else if (records.length == 1) {
	            isOneRecord = true;
                records = [record];
            } else if (records.length > 1) {
	            isOneRecord = false;
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
        
        if (isOneRecord) {
            return listSObjects[0];
        } else {
            return listSObjects;            
        }
    },
    getForceRefresh : function(component, forceRefreshParam) {
        var forceRefresh = component.get("v.forceRefresh");
        if (!(forceRefreshParam === undefined)) {
            forceRefresh = forceRefreshParam;
        }
        if (forceRefresh === undefined) {
            debugger;
            throw new ("forceRefresh is not defined!");
        } else {
            console.log("forceRefresh: " + forceRefresh);
        }
        return forceRefresh;
    },
    fireMessageEvent : function(component, isShow, message, type) {
        var evApp = $A.get("e.c:ETLC_PleaseWaitEvent");
        var params = {
            isShow: isShow
        };
        if (type) {
            params.type = type;
        };
        if (message) {
            params.message = message;
        };
        evApp.setParams(params);
        evApp.fire();
    }
})