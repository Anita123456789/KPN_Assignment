/* Author : Anita Satpute
 * Date : 10/03/2022
 * Function : This class is created to perform operations for lwc controller class
 */
public class OrderConfirmationHelper {
	
    /*
    * Description : This method call the check Activate the order 
    */ 
    public static string confirmOrder (Id OrderId) {
        
        try {
			//get the order details by id
			Order order = OrderHandler.getOrderDetails(orderId);  
            
            if (order != null) {
                //Form the request body
                OrderDataWrapper requestBody = OrderHandler.getRequestBody(order);
                
                if (requestBody != null ) {
                    
                     HTTPResponse HttpResonseObj = new HTTPResponse();
        			 HttpResonseObj = OrderHandler.sendOrderDetail(JSON.serialize(requestBody));
                    
                    	if (HttpResonseObj.getStatusCode() == 200) {
                            OrderHandler.afterOrderConfirmationProcess(orderId);
                            return 'Order Confirmed Successfully.!';
                            
                        } else {
                            throw new AuraHandledException('Connection Error,Please contact your administrator.');
                        }
                }
            }
        } catch (exception e) {
        	throw new AuraHandledException('Connection Error,Please contact your administrator.');
        }      
        
        return 'true';
    }
}