/* Author : Anita Satpute
 * Function : This is a server side controller for orderConfirmation LWC component.
 * This class is design to perform the fullfilment of order by sending the request to other systems 
 * if the success response (200 code)  then update order and its like items
 */
public with sharing class OrderConfirmationServerSideController {
    
	@AuraEnabled (cacheable=false)
    public static string confirmOrder(String orderId) { 		
        return OrderConfirmationService.confirmOrder(orderId);
    }
}