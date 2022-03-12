@isTest
public class AvailableProductsControllerTest {

    @istest 
    public static void getAvailableProductsTest() {
        Order order = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();
    	Id pricebookId = Test.getStandardPricebookId();
        
        List<PricebookEntry> priceBookEntry = AvailableProductsController.getAvailableProducts(pricebookId);
        System.assertEquals(1, priceBookEntry.size());

    }
    
    @istest
    public static void addOrderProducts_positiveScenario() {
        order orderRec = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntrywithProd(productRec.Id);      
        List<orderItem> tobeInsertedList = new List<orderItem>();
        tobeInsertedList.add(new OrderItem(Product2Id= productRec.id,
                                               UnitPrice=100,
                                               Quantity=1,
                                           	   OrderId=orderRec.Id));
        
      
        Boolean result = AvailableProductsController.addOrderProducts(tobeInsertedList,orderRec.Id,TestDataFactory.getPricebookId());
        System.assertEquals(false,result);       
    }
    
    @isTest
    public static void existingProductCheck_positiveScenario() {
    	Order order = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntrywithProd(productRec.Id);      
        List<orderItem> orderItemList = TestDataFactory.createOrderLineItem(order,PBE);
        List<orderItem> tobeInsertedList = new List<orderItem>();
        tobeInsertedList.add(new OrderItem(Product2Id= productRec.id,
                                               UnitPrice=100,
                                               Quantity=1,
                                           	   OrderId=order.Id));
        Boolean result = AvailableProductsController.addOrderProducts(tobeInsertedList,order.Id,TestDataFactory.getPricebookId());
        System.assertEquals(true,result); 
    }
}