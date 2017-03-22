@isTest
public class ETLC_ApexBridge_Abstract_test {
    @isTest
    public static void testNonAbstractMethods() {
        ETLC_ApexBridge_TestHelper abs = new ETLC_ApexBridge_TestHelper();
        
        Date dt = Date.today();
        Date dt2 = abs.dateFromJSON(abs.dateToJSON(dt));
        System.assertEquals(dt, dt2);
        
        DateTime dttm = DateTime.now();
        DateTime dttm2 = abs.dateTimeFromJSON(abs.dateTimeToJSON(dttm));
        System.assertEquals(dttm, dttm2);
    }    
}