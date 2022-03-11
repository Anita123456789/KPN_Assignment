/* Author : Anita Satpute
 * Date   : 8/02/2022
 * Description : This Class will be invoked by the LWC component AvailableProducts 
 * 
 */
public class AvailableProductsController {

    @AuraEnabled (cacheable=true)
    public static List<PricebookEntry> getAvailableProducts (String priceBookId) {
         return AvailableProductsHelper.getPriceBookEntryData(priceBookId);        
    }
    
    @AuraEnabled (cacheable=false)
    public static boolean addOrderProducts (List<orderItem> orderItemRecordList, String orderId, String PricebookId) {
        return AvailableProductsHelper.addOrderProducts (orderItemRecordList,orderId,PricebookId);
    }
    
}