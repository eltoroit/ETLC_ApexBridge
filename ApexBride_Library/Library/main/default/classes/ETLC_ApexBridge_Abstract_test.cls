@isTest
public class ETLC_ApexBridge_Abstract_test {
	@isTest
    public static void testNonAbstractMethods() {
        AbstractBasicImplementation abs = new AbstractBasicImplementation();
        
        Date dt = Date.today();
        Date dt2 = abs.dateFromJSON(abs.dateToJSON(dt));
        System.assertEquals(dt, dt2);
        
        DateTime dttm = DateTime.now();
        DateTime dttm2 = abs.dateTimeFromJSON(abs.dateTimeToJSON(dttm));

        String strDTTM = ETLC_ApexBridge_Abstract.encodeData(dttm);
        DateTime dttm3 = (DateTime) ETLC_ApexBridge_Abstract.decodeData(strDTTM, DateTime.class);
        // System.assertEquals(dttm, dttm3);
    }

    public class AbstractBasicImplementation extends ETLC_ApexBridge_Abstract {
        public override void process(ETLC_ApexBridge_Request request, ETLC_ApexBridge_Response response) {
            // Nothing
        }
    }
}