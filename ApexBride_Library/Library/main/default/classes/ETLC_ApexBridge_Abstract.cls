public abstract class ETLC_ApexBridge_Abstract {
    public abstract void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response);
    
    // JSON Date / DateTime
    // In Javascript this instruction (new Date(aDate)).toJSON();
    // produces something of this format: 2016-07-04T14:03:06.283Z
    // And new Date(strDate) gets you the date/time value
    // These methods helps Apex communicate back and forth with the JavaScript client
    
    public Date dateFromJSON(String dt) {
        return dateTimeFromJSON(dt).date();
    }   
    public DateTime dateTimeFromJSON(String dttm) {
        dttm = dttm.replace('T', ' ');
        dttm = dttm.split('\\.')[0];
        return DateTime.valueOfGmt(dttm);
    }
    public String dateToJSON(Date dt) {
        DateTime dttm = DateTime.newInstance(dt.year(), dt.month(), dt.day());
        return dateTimeToJSON(dttm);
    }
    public String dateTimeToJSON(DateTime dttm) {
        return dttm.formatGMT('yyyy-MM-dd') + 'T' + dttm.formatGMT('HH:mm:ss.SSS') + 'Z';
    }

    public static String encodeData(Object value) {
        System.debug(value);
        return JSON.serialize(value);
    }
    
    public static Object decodeData(String value, Type t) {
        System.debug(value);
        return JSON.deserializeStrict(value, t);
    }
}