@istest
public class ProductInfoControllerTest {
    
    @testSetup
    Private static void setupData()
    {
        Product2 prod = new Product2(name = 'Standard');
        insert prod;
        
        Service__c ser =new Service__c(name = 'Card Replacement Cost');
        Service__c ser2 =new Service__c(name = 'ATM Fee in other currencies');
        Service__c ser3 =new Service__c(name = 'Cost per Calendar Month');
        insert new List<Service__c>{ser,ser2, ser3};
            
        Service_Charges__c cost = new Service_Charges__c(Product__c = prod.id,
                                                             Service__c = ser.id,
                                                             Cost__c = double.valueOf(12),
                                                             Country__c = 'DE');
        Service_Charges__c cost2 = new Service_Charges__c(Product__c = prod.id,
                                                          Service__c = ser2.id,
                                                          Cost__c = double.valueOf(12),
                                                          Country__c = 'DE');
        Service_Charges__c cost3 = new Service_Charges__c(Product__c = prod.id,
                                                          Service__c = ser3.id,
                                                          Cost__c = double.valueOf(12),
                                                          Country__c = 'DE');
        insert new List<Service_Charges__c>{cost, cost2, cost3};
            
            Contact  cont = new Contact(lastname = 'Test',
                                        Product__c = prod.Id,
                                        language__c = 'en',
                                        UUID__c = '123456',
                                        Home_Country__c = 'DE');
        insert cont;
        
        Case c = new Case(Subject = 'Testing the case',
                          Status = 'New',
                          Origin = 'Phone',
                          Contactid = cont.id);
        insert c;
        
    }
    
    @istest
    private static void TestVontoller(){
        Id caseId = [Select id from Case where Status ='New'].id;
        
        test.startTest();
        Case c = ProductInfoController.getCaseInfo(caseId);
        List<Service_Charges__c> info = ProductInfoController.getProductInfo(c.Contact.Product__c, c.Contact.Home_Country__c);
        test.stopTest();
        
        system.assert(c.Contact.Product__r.Name == 'Standard');
        System.assert(info.size() == 3);
    }
    
}