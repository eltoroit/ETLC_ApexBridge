// This is the communication bridge data between LC and Apex
public class ETLC_ApexBridge_Request {
    public enum MessageType {Errors, Warnings, Information}
    
    @AuraEnabled public String controller { get; set; }
    @AuraEnabled public String method { get; set; }
    @AuraEnabled public String input { get; set; }
    @AuraEnabled public String output { get; set; }
    @AuraEnabled public List<SObject> records { get; set; }
    @AuraEnabled public Boolean debug {
		get {
			if (debug == null) debug = false;
            return debug;
		}
		set;
	}
    @AuraEnabled public Boolean isSuccess {
        get {
            if (isSuccess == null) isSuccess = true;
            return isSuccess;
        }
        set;
    }
    @AuraEnabled public Map<MessageType, List<String>> messages {
        get {
            if (messages == null) messages = new Map<MessageType, List<String>>();
            return messages;
        }
        set;
    }
    @AuraEnabled public boolean doesCallout {
        get {
            if (doesCallout == null) doesCallout = false;
            return doesCallout;
        }
        set;
    }
    
    public void addMessage(MessageType msgType, String text) {
        List<String> ls = new List<String>();
        if (messages.containsKey(msgType)) ls = messages.get(msgType);
        ls.add(text);
        messages.put(msgType, ls);
        if (msgType == MessageType.Errors) {
            isSuccess = false;
            // throw new BlogException('Debbuging Error: ' + text);
        }
    }
    public Object getInputValue(String key) {
        Map<String, Object> inputMap = (Map<String, Object>) JSON.deserializeUntyped(input);  
        return inputMap.get(key);
    }
    public Date getInputDate(String key) {
        String tmp = (String) getInputValue(key);
        // JSON requires this value to be enclosed in double quotes
        if (tmp.left(1) != '"')  tmp = '"' + tmp + '"';
        Date dt = (Date) JSON.deserialize(tmp, Date.class);
        return dt;
    }
    public DateTime getInputDateTime(String key) {
        String tmp = (String) getInputValue(key);
        // JSON requires this value to be enclosed in double quotes
        if (tmp.left(1) != '"')  tmp = '"' + tmp + '"';
        DateTime dttm = (DateTime) JSON.deserialize(tmp, DateTime.class);
        return dttm;
    }
    public String toJSON() {
        return JSON.serialize(this);
    }
    public static ETLC_ApexBridge_Request fromJSON(String strJson) {
        // System.debug('***' + strJson);
        ETLC_ApexBridge_Request data = (ETLC_ApexBridge_Request) JSON.deserializeStrict(strJson, ETLC_ApexBridge_Request.class);
        // System.debug('***' + data);
        return data;
    }
    public static String encodeData(Object value) {
    	if (value == null) return '';
        return JSON.serialize(value);
    }
    public static Object decodeData(String value, Type t) {
        return JSON.deserializeStrict(value, t);
    }
}