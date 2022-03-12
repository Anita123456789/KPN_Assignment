/* Author : Anita Satpute
 * Date   : 9/03/2022
 * Description : This class is definded to perform the operations for LWC component orderProducts
 * 
 */
public class OrderProductsService {

    //Method is define to fetch the order items associated with order
    public static List<OrderItem> getOrderItems (Id OrderId) {
        
         return [ Select Id,Product2Id,Product2.Name,UnitPrice,TotalPrice,Quantity,OrderId
                  From OrderItem 
                  WHERE orderId =: orderId WITH SECURITY_ENFORCED];
    }
}