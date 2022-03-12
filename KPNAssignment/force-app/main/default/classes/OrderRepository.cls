/*	Author : Anita Satpute
 *  Functionality : This Class will handle all the operations on order Items object
 * */
public class OrderRepository {
    /*
    * Description : This method will insert the order products 
    */
    public static boolean insertOrderItemList (List<orderItem> toBeInsertedOrderItemList) {
        
        boolean isSuccess = true;
        if (toBeInsertedOrderItemList != null && !toBeInsertedOrderItemList.isEmpty()) {            
            List<Database.SaveResult> saveResultList = Database.insert(toBeInsertedOrderItemList, false); 
            for (Database.SaveResult sr : saveResultList ){
                if (!sr.isSuccess()) {
                    system.debug('error:'+sr.getErrors());
                    isSuccess= false;
                }
            }
        }
        return isSuccess;
    }
    
    /*
    * Description : This method will update the order products 
    */
    public static boolean updateOrderItemList (Map<Id,orderItem> toBeUpdatedOrderItemList) {
        boolean isSuccess = true;
        
        if (toBeUpdatedOrderItemList.values() != null && !toBeUpdatedOrderItemList.isEmpty()) {            
            List<Database.SaveResult> saveResultList = Database.update(toBeUpdatedOrderItemList.Values(), false); 
            for (Database.SaveResult sr : saveResultList ) {
                if (!sr.isSuccess()) {
                    system.debug('error:'+sr.getErrors());
                    isSuccess= false;
                }
            }
        }
        return isSuccess;
    }
}