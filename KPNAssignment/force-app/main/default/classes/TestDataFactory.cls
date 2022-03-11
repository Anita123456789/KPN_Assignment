@isTest
public class TestDataFactory {
    public static Account createAccount() {
         Account account = new Account();
         account.Name = 'Test Account';
         insert account;
        return account;
    }
    public static Product2 createProduct(){
		Product2 product = new Product2();
        product.Name = ' Test Product ';
        product.Description='Test Product Entry 1';
        product.productCode = 'ABC';
        product.isActive = true;
        insert product;
        return product;
    }
    
    public static Id getPricebookId() {
        Id pricebookId = Test.getStandardPricebookId();
		return pricebookId;
    }
    
    public static PricebookEntry createPricebookEntry () {
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = TestDataFactory.getPricebookId();
        Product2 prodduct2Rec = new Product2();
        prodduct2Rec = TestDataFactory.createProduct();
        standardPrice.Product2Id = prodduct2Rec.Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        return standardPrice;
    }
    public static PricebookEntry createPricebookEntrywithProd(string prodduct2Id) {
        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = TestDataFactory.getPricebookId();
        standardPrice.Product2Id = prodduct2Id;
        standardPrice.UnitPrice = 1;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice ;
        return standardPrice;
    }
    public static Order createOrders() {
        Order order = new Order();
        order.Name = 'Test Order ';
        order.Status = 'Draft';
        order.EffectiveDate = system.today();
        order.EndDate = system.today() + 4;
        order.AccountId = TestDataFactory.createAccount().id;
        order.Pricebook2Id =  TestDataFactory.getPricebookId();
        insert order;
        return order;
    }
    
    public static List<OrderItem> createOrderLineItem(Order order,PricebookEntry priceBookEntryRec) {
        List<orderItem> orderItemList = new List<OrderItem>();
        for(integer i=0;i<6;i++) {
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = order.id;
            orderItem.Quantity = 24;
            orderItem.UnitPrice = 240;
            orderItem.Product2id = TestDataFactory.createProduct().id;
            orderItem.PricebookEntryId=priceBookEntryRec.id;
            orderItemList.add(orderItem);
        }
        insert orderItemList;
        return orderItemList;
    }
}