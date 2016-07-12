// This is the communication bridge data between LC and Apex
public class ETLC_ApexBridge_Data {
    public enum MessageType {Errors, Warnings, Information}
    
    @AuraEnabled
    public String operation { get; set; }
    
    @AuraEnabled
    public String input { get; set; }
    
    @AuraEnabled
    public String output { get; set; }
    
    @AuraEnabled
    public Boolean debug { get; set; }
    
    @AuraEnabled
    public Boolean isSuccess {
        get {
            if (isSuccess == null) isSuccess = true;
            return isSuccess;
        }
        set;
    }
    
    @AuraEnabled
    public Map<MessageType, List<String>> messages {
        get {
            if (messages == null) messages = new Map<MessageType, List<String>>();
            return messages;
        }
        set;
    }
    
    @AuraEnabled
    public List<SObject> records { get; set; }
    
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
    
    public String toJSON() {
        return JSON.serialize(this);
    }
    public static ETLC_ApexBridge_Data fromJSON(String strJson) {
        return (ETLC_ApexBridge_Data) JSON.deserializeStrict(strJson, ETLC_ApexBridge_Data.class);
    }
    
    public static String encodeData(Object value) {
        return JSON.serialize(value);
    }
    public static Object decodeData(String value, Type t) {
        return JSON.deserializeStrict(value, t);
    }
}