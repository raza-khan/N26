/*Class: CustomProductResource
 * Description: The purpose of this class have write the rest API for the external
 * .            system to retrieve the data of customer product from Salesforce
 * 
 * 
 * **/
 @RestResource(urlMapping='/CustomerProduct/*')
global with sharing class CustomProductResource {
    
    /* Method:doGet
     * This method is being provide the implementation of Http Get which is 
     * being invoked from. the external system and send UUID of the customer
     *  and it return product information in response.
     * 
     * */
    @HttpGet
    global static CustomProductWrapper doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String uuid = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        CustomProductWrapper jsonResponse = getCustomerProductJson(uuid);
        return jsonResponse;
    }
    
    /* Method:getCustomerProductJson
     * This method is helper method to generate the response for the given
     *  customer Id
     * 
     * */
    private static CustomProductWrapper getCustomerProductJson( String customerId )
    {
        string response;
        CustomProductWrapper wrapper = new CustomProductWrapper();
        CustomProductWrapper.Error error = new CustomProductWrapper.Error();
        wrapper.error = error;
        try{
            List<Contact> customers = [SELECT Id,name, Product__c,Product__r.name, Phone, Home_Country__c, UUID__c  FROM Contact WHERE UUID__c  =: customerId];
            
            if(customers != null && customers.size() > 0){
                Contact cont = customers[0];
                if(cont.Product__c != null){
                    
                    wrapper.customerName = cont.Name;
                    wrapper.country = cont.Home_Country__c;
                    wrapper.productName = cont.Product__r.Name;
                    wrapper.uUid = cont.UUID__c;
                    wrapper.services = new List<CustomProductWrapper.ServiceInfo>();
                    
                    for(Service_Charges__c service: [SELECT Id, Service__r.Name, Cost__c, Country__c, Product__r.Name, Percentage_Cost__c,Currency_Code__c
                                                     FROM Service_Charges__c WHERE Product__c=:cont.Product__c And Country__c =: cont.Home_Country__c])
                    {
                        CustomProductWrapper.ServiceInfo serviceInfo = new CustomProductWrapper.ServiceInfo();
                        serviceInfo.serviceName = service.Service__r.Name;
                        serviceInfo.chargesAmount = service.Cost__c;
                        serviceInfo.chargesPercent = service.Percentage_Cost__c;
                        // since multi currency cannot be enabled in Dev org so created a custom field
                        if( wrapper.currencyCode == null )
                            wrapper.currencyCode = service.Currency_Code__c;
                        serviceInfo.isFfree = ((service.Cost__c == null || service.Cost__c==0) && (service.Percentage_Cost__c == null|| service.Percentage_Cost__c ==0))? true: false;
                       
                        wrapper.services.add(serviceInfo);
                    }
                    response = JSON.serialize(wrapper);
                    
                }else{
                    
                    error.errorMessage = 'The customer is not subscribed to any product';
                    response = JSON.serialize(error);
                    
                }
                
            }else{
                error.errorMessage = 'No customer found for the given Id';
                response = JSON.serialize(error);
                
            }
        }Catch(Exception ex){
            error.errorMessage = ex.getMessage();
            response = JSON.serializePretty(error);
        }
        return wrapper;  
        
    }
}