public abstract class ETLC_ApexBridge_Abstract {
    public abstract Object handleRequest(ETLC_ApexBridge_Request request);
    
    public void process(ETLC_ApexBridge_Request request) {
        try {
            Object output = handleRequest(request);
            request.output = (output == null ? '""' : ETLC_ApexBridge_Request.encodeData(output));
        } catch (Exception ex) {
            String err = 'Unexpected method received (' + request.method + ')';
            throw new ETLC_Exception(err);  
        }
    }
    
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
}