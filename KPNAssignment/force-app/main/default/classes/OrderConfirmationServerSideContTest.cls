@isTest
public class OrderConfirmationServerSideContTest {
    @istest 
    public static void confirmOrderProcess_Positive(){
         Id pricebookId = Test.getStandardPricebookId();
        order orderRec = TestDataFactory.createOrders();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();
        List<orderItem> orderItemList = TestDataFactory.createOrderLineItem(orderRec,PBE);
        test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockRequestCatcherRespGenerator());
         OrderDataWrapper wrapper = new OrderDataWrapper();	
         string output = OrderConfirmationServerSideController.confirmOrder(orderRec.Id);
         System.assertEquals('Order Confirmed Successfully.!', output);
        test.stopTest();
    }
    
    @istest
    public static void confirmOrderProcess_Negative(){
        order orderRec = TestDataFactory.createOrders();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();
        List<orderItem> orderItemList = TestDataFactory.createOrderLineItem(orderRec,PBE);

        test.startTest();
         Test.setMock(HttpCalloutMock.class, new MockRequestCatcherRespGenerator());
         string output = OrderConfirmationServerSideController.confirmOrder(orderRec.Id);
        test.stopTest();
    }

}