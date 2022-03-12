/* Author : Anita Satpute
 * Date   : 8/03/2022
 * Description : This class will help the Controller class to perform the operations 
 * 
 */
public class AvailableProductService {

   /*
    * Description : This method will fetch the price book entry 
    */ 
   public static List<PricebookEntry> getPriceBookEntryData (String priceBookId) {
        return [SELECT Id,Pricebook2Id,pricebook2.Name,Product2.Name,UnitPrice 
                FROM  PricebookEntry
                WHERE Pricebook2Id =: priceBookId WITH SECURITY_ENFORCED];
    }
    
    /*
    * Description : This method will add the order products and update if already exist. 
    */ 
	public static boolean addOrderProducts (List<orderItem> orderItemRecordList, String orderId, String PricebookId) {
		try{ 
			boolean isSuccessful = true;
			List<OrderItem> orderProductList = new List<OrderItem>();
			Map<Id,orderItem> orderProductMap = new Map<Id,orderItem>();
			Map<Id,orderItem> existingOrderItemMap = new Map<Id,orderItem>();
			
			//To fetch the existing order items
			for (OrderItem orderitem : [Select Id,Product2Id,Quantity,OrderId From OrderItem WHERE orderId =: orderId]) {
				existingOrderItemMap.put(orderitem.Product2Id,orderitem);
			}
			
			 //To associate product and its pricebookentry
			Map<Id,PricebookEntry> pricebookIdMap = new Map<Id,PricebookEntry>();
            for (PricebookEntry pricebookEntryRec : [Select id,Pricebook2Id,Product2Id from PricebookEntry WHERE Pricebook2Id =: PricebookId ]) {
				pricebookIdMap.put(pricebookEntryRec.Product2Id,pricebookEntryRec);
			}
			
			for (OrderItem orderItem : orderItemRecordList) {
			   if( existingOrderItemMap.containskey(orderItem.Product2Id)) {//Check if order item already exist
                   OrderItem orderItemRec = new OrderItem();
				   orderItemRec.id = existingOrderItemMap.get(orderItem.Product2Id).Id;
				   orderItemRec.Quantity = existingOrderItemMap.get(orderItem.Product2Id).Quantity+1;                
				   orderProductMap.put(orderItem.Id,orderItemRec);
                   
				} else {
					orderItem neworderItem = new orderItem();
					neworderItem.Quantity = orderItem.Quantity;
					neworderItem.Product2id = orderItem.Product2Id;
					neworderItem.UnitPrice = orderItem.UnitPrice;
					neworderItem.orderId= orderItem.OrderId;
					neworderItem.ListPrice = orderItem.UnitPrice;
                    
					if (pricebookIdMap.containskey(orderItem.Product2Id)) {
						 neworderItem.PricebookEntryId = pricebookIdMap.get(orderItem.Product2Id).Id;
					}                                  
					orderProductList.add(neworderItem);
				}
			}
			
			if (orderProductList != null && !orderProductList.isEmpty()){
				 isSuccessful = OrderRepository.insertOrderItemList(orderProductList);
			}
			if (orderProductMap != null && !orderProductMap.isEmpty()){
				isSuccessful= OrderRepository.updateOrderItemList(orderProductMap);
			}
					 
			return isSuccessful;
			  
		} catch (exception e) {
			throw new AuraHandledException('Operation failed,Please contact your administrator.');
		} 
	}
}