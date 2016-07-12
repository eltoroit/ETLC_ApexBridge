@isTest
public class ETLC_ApexBridge_ClientTestHelper {
    public String operation { get; set; }
    public Map<String, String> input { get; set; }
    public List<SObject> records { get; set; }

    public String validate() {
        // Prepare the data to simulate the client calling the controller
        ETLC_ApexBridge_Data dataIn = new ETLC_ApexBridge_Data();
        dataIn.operation = operation;
        dataIn.input = ETLC_ApexBridge_Data.encodeData(input);
        dataIn.records = records;
		dataIn.debug = true;
		String dataJson = dataIn.toJSON();

        // Call the controller as the client would do.
        Test.startTest();
        dataJson = ETLC_ApexBridge_Controller.execute(dataJson);
        ETLC_ApexBridge_Data dataOut = ETLC_ApexBridge_Data.fromJSON(dataJson);
        Test.stopTest();
        
        // Basic asserts
        System.assertEquals(dataIn.input, dataOut.input);
        System.assertEquals(dataIn.operation, dataOut.operation);
        return dataOut.output;
    }
}