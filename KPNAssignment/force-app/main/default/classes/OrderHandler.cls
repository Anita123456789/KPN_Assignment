/*	Author : Anita Satpute
 *  Functionality : This class will handle all the operations on order object
 * */
public class OrderHandler {
    
    //To fetch the order and its associated order items 
    public static Order getOrderDetails(String orderId) {
        
        return [SELECT Id,OrderNumber,AccountId,Type,Status,
                (SELECT Id,Product2.Name,Product2.ProductCode,Quantity,UnitPrice from OrderItems)
                FROM Order
                WHERE Id =:orderId WITH SECURITY_ENFORCED];
    }
    
    //To generate the request body
    public static OrderDataWrapper getRequestBody(Order order) {
        
     try{  
        if (order != null) {            
            OrderDataWrapper requestbody = new OrderDataWrapper();
            requestbody.orderNumber = order.OrderNumber;
            requestbody.accountNumber = order.AccountId;
            requestbody.status = order.Status;
            requestbody.type = order.Type;
            
            List<OrderDataWrapper.OrderProducts> orderProductList = new List<OrderDataWrapper.OrderProducts>();
            
            if (order.orderItems != null && !order.orderItems.IsEmpty()) {
                
                for (OrderItem OrderItemRecord : order.orderItems) {
                    OrderDataWrapper.OrderProducts orderProduct = new OrderDataWrapper.OrderProducts();
                    orderProduct.code = 	 OrderItemRecord.Product2.ProductCode;
                    orderProduct.name =		 OrderItemRecord.Product2.Name;
                    orderProduct.quantity =  OrderItemRecord.Quantity;
                    orderProduct.unitPrice = OrderItemRecord.UnitPrice;
                    orderProductList.add(orderProduct);
                }
            }
            
            if (orderProductList != null && !orderProductList.isEmpty()) 
                requestbody.orderProducts = orderProductList;            
            
            return requestbody;
        } else 
            return new OrderDataWrapper();
         
      } catch (exception e){
         throw new AuraHandledException('Connection Error,Please contact your administrator.');
      }
        
    }

    //To send the request 
    public static HTTPResponse sendOrderDetail(String requestBody) {
     try{
            HttpRequest RequestObject   = new HttpRequest();
            RequestObject.setEndpoint('callout:KPNAssignment');
            RequestObject.setMethod('POST');
            RequestObject.setBody(requestBody);
         
            Http http = new Http();         
            HTTPResponse ResponseObject = http.send(RequestObject); 
         
             return ResponseObject;
         } catch(exception e) {
             throw new AuraHandledException('Connection Error,Please contact your administrator.');
         }
        
    }
    
	//To update the order records.
    public static void afterOrderConfirmationProcess (string orderRecordId) {
        
        Order orderRecord = OrderHandler.getOrderDetails(orderRecordId);
        orderRecord.Id = orderRecordId;
        orderRecord.Status = 'Activated';
        Update OrderRecord;
        Map<Id,orderItem> tobeUpdatedorderItemMap = new Map<Id,orderItem>();
        for(orderItem orderItemRec : orderRecord.OrderItems) {
            orderItemRec.Status__c = 'Activated';
            tobeUpdatedorderItemMap.Put(orderItemRec.id,orderItemRec);
        }
        
        OrderRepository.updateOrderItemList(tobeUpdatedorderItemMap);      
    }
}