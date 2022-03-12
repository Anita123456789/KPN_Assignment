/* Author : Anita Satpute
 * Date   : 8/03/2022
 * Description : This Class will be invoked by the LWC component AvailableProducts 
 * 
 */
public class AvailableProductsController {

    @AuraEnabled (cacheable=true)
    public static List<PricebookEntry> getAvailableProducts (String priceBookId) {
         return AvailableProductService.getPriceBookEntryData(priceBookId);        
    }
    
    @AuraEnabled (cacheable=false)
    public static boolean addOrderProducts (List<orderItem> orderItemRecordList, String orderId, String PricebookId) {
        return AvailableProductService.addOrderProducts (orderItemRecordList,orderId,PricebookId);
    }
    
}