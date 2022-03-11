/* Author : Anita Satpute
 * Date   : 9/02/2022
 * Description : This Class will be invoked by the LWC component OrderProducts to display order products available for Order 
 * 
 */
public class OrderProductsController {

     //Method is define to fetch the order items associated with order
    @AuraEnabled (cacheable=true)
    public static List<OrderItem> getOrderProducts (String orderId) {
        return OrderProductsHelper.getOrderItems(orderId);
    }
}