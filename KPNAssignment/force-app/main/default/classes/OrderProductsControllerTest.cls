@isTest
public class OrderProductsControllerTest {
	
    @istest 
    public static void getProducts_Positive() {
        Order order = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();
    	test.startTest();
            OrderProductsController.getOrderProducts(order.Id);
        test.stopTest();
    }
}