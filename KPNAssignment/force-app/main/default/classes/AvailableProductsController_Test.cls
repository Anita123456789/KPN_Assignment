@isTest
public class AvailableProductsController_Test {

    @istest 
    public static void getProducts_Positive() {
        Order order = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();
    	test.startTest();
            AvailableProductsController.getAvailableProducts(order.Id);
        test.stopTest();
    }
    
    @istest
    public static void addOrderProducts_positive() {
        order orderRec = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();      
        List<orderItem> tobeInsertedList = new List<orderItem>();
        tobeInsertedList.add(new OrderItem(Product2Id= productRec.id,
                                               UnitPrice=100,
                                               Quantity=1,
                                           	   OrderId=orderRec.Id));
        
        test.starttest();
        AvailableProductsController.addOrderProducts(tobeInsertedList,orderRec.Id,TestDataFactory.getPricebookId());
        test.stoptest();
    }
    
    @isTest
    public static void existingProduct_positive() {
    	Order order = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();      
        List<orderItem> orderItemList = TestDataFactory.createOrderLineItem(order,PBE);
        List<orderItem> tobeInsertedList = new List<orderItem>();
        tobeInsertedList.add(new OrderItem(Product2Id= productRec.id,
                                               UnitPrice=100,
                                               Quantity=1,
                                           	   OrderId=order.Id));
        test.starttest();
        	AvailableProductsController.addOrderProducts(tobeInsertedList,order.Id,TestDataFactory.getPricebookId());
        test.stoptest();
    }
}