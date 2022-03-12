@isTest
public class OrderProductsControllerTest {
	
    @istest 
    public static void getOrderProductDataTest() {
         Id pricebookId = Test.getStandardPricebookId();
        Order order = TestDataFactory.createOrders();
        Product2 productRec = TestDataFactory.createProduct();
        PricebookEntry PBE = TestDataFactory.createPricebookEntry();
    	List<orderItem> orderItemList = TestDataFactory.createOrderLineItem(order,PBE);

        List<OrderItem> orderItems = OrderProductsController.getOrderProducts(order.Id);
        System.assertEquals(5,orderItems.size()); 

    }
}