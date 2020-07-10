/* CustomProductWrapper:
 * Description: It is the wrapper clss to generate 
 * the response of customer api in json format.
* 
* */
global class CustomProductWrapper {
    Public string customerName {get; set;}
    public string uUid { get; set; }
    public string productName { get; set; }
    public string country { get; set; }
    Public List<ServiceInfo> services { get; set; }
    public string currencyCode { get; set; }
    public Error error {get; set;}
    
    
    public class ServiceInfo{
        public string serviceName { get; set; }
        
        public Decimal chargesPercent { get; set; }
        public Decimal chargesAmount { get; set; }
        public boolean isFfree { get; set; }
        
    }
    // to send the error message in case of any issue
    public class Error{
        public string errorMessage { get; set; }
    }
    
}