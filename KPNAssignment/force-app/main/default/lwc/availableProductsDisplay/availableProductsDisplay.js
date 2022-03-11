import { LightningElement ,wire,api  } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord,getRecordNotifyChange } from 'lightning/uiRecordApi';
import PRICEBOOK_ID from '@salesforce/schema/Order.Pricebook2Id';
import ORDERSTATUS from '@salesforce/schema/Order.Status';
import getProductData from '@salesforce/apex/AvailableProductsController.getAvailableProducts';
import addOrderProducts from '@salesforce/apex/AvailableProductsController.addOrderProducts';
import { publish, MessageContext } from 'lightning/messageService';
import productsAddedEvent from '@salesforce/messageChannel/productsAddedEvent__c';
import error_Message from '@salesforce/label/c.Error_Message';
import productNotSelected from '@salesforce/label/c.ProductNotSelected';
import successfulProdAdded from '@salesforce/label/c.SuccessfulProdAdded';

const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'List Price',fieldName: 'UnitPrice'}
];


export default class AvailableProductsDisplay extends LightningElement {

    @api recordId;
	/** View controller attributes */
		showTable=true;
		showButton=true;

    /** Custom Labels */
    labels = {
        error_Message,
        productNotSelected,
        successfulProdAdded
    }

	/** dataTable controller attributes */
		columns; 
		productData = [];
		orderItemProducts = [];
	
	/**Pagination controller attributes */	
		page = 1;
		items = []; 
		startingRecord = 1; 
		endingRecord = 0; 
		pageSize = 5; 
		totalRecountCount = 0; 
		totalPage = 0; 

    /**to get the current orders data */    
    @wire(getRecord, { recordId: '$recordId', fields: [PRICEBOOK_ID,ORDERSTATUS] })
    orderData({ error, data }){
		
        if (data){            
            this.PRICEBOOK_ID =data.fields.Pricebook2Id.value;
            this.ORDERSTATUS =data.fields.Status.value;
			/** to control availability to add products */
            if (this.ORDERSTATUS == 'Activated') {
                this.showButton = false;
            }
			
            if (this.PRICEBOOK_ID ){
				/** to get the product entries associated to the order */
                getProductData({
                    priceBookId: this.PRICEBOOK_ID
                })
                .then (result => {
					
                    for (let itdtCol of result) {
                        this.columns = columns;
						this.items.push({Name: itdtCol.Product2.Name,UnitPrice: itdtCol.UnitPrice,id: itdtCol.Product2Id});
					}
					
                    this.totalRecountCount = result.length; 
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize);
                    this.productData = this.items.slice(0,this.pageSize);
                    this.endingRecord = this.pageSize;
					
                })
                .catch (error => {

                    this.ShowToastEvent('Error',this.labels.error_Message,'error');
			        this.showTable = false;
                }); 
                
            }else {

                this.ShowToastEvent('Error',this.labels.error_Message,'error');
                this.showTable = false;
            }
        
        } 
		
        else if (error) {
			console.log(error);
			this.error = error;
        }
    }
	
	/** to send the product added method */
    @wire(MessageContext) 
    messageContext;


    /** Pagination logic */
    previousHandler() {
		
        if (this.page > 1) {
            this.page = this.page - 1; 
            this.displayRecordPerPage(this.page);
        }
    }
	
    nextHandler() {
		
        if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; 
            this.displayRecordPerPage(this.page);            
        }             
    }
	
    displayRecordPerPage(page){
		
        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);
        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                            ? this.totalRecountCount : this.endingRecord; 
        this.productData = this.items.slice(this.startingRecord, this.endingRecord);
        this.startingRecord = this.startingRecord + 1;
    }    

	/** method to add the order Products*/
    addProducts () {

		try{		
			var el = this.template.querySelector('lightning-datatable');
			var selected = el.getSelectedRows();
			
			if (selected.length ==0) {
				
				this.ShowToastEvent('Error',this.labels.productNotSelected,'error');
							 
			} else {
				for (let selectedRec of selected) {
					/**List of Order Items Preparation */
					this.orderItemProducts.push({
						sObjectType: 'OrderItem',
						Product2Id: selectedRec.id,
						UnitPrice: selectedRec.UnitPrice,
						Quantity:1,
						OrderId:this.recordId});
				}
				
				if (this.orderItemProducts) {
					addOrderProducts({
						orderItemRecordList: this.orderItemProducts,
						orderId: this.recordId,
						PricebookId: this.PRICEBOOK_ID
					})
					.then (result => {
						
						if (result) {
							
							const payload = { recordId: this.recordId};
							publish(this.messageContext, productsAddedEvent, payload);
							
							this.ShowToastEvent('Successful',this.labels.successfulProdAdded);
							
						}else {
							
							this.ShowToastEvent('Error',this.labels.error_Message,'error');
						}
					})
					.catch(error => {
                        						
						this.ShowToastEvent('Error',this.labels.error_Message,'error');
					
					});
				}
			}
			
		}catch(error)  {
			
			this.ShowToastEvent('Error',this.labels.error_Message,'error');
			console.log(error);
			
		}
    }
	
	/** Method to fire the show toast event*/
    ShowToastEvent(title,message,variant){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant||'success',
                mode: 'dismissable'
            })
        );
    }
}