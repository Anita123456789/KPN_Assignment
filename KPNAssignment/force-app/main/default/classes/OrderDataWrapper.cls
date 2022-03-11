/*	Author : Anita Satpute
 *  Functionality : This class is created to get response struture
 * */
public with sharing class OrderDataWrapper {
    
    public String accountNumber;
    public string orderNumber;
    public String type;
    public String status;
    public List<OrderProducts> orderProducts;
    
    public class OrderProducts{
        public String name;
        public String code;
    	public decimal unitPrice;
    	public decimal quantity;
	}
    
}