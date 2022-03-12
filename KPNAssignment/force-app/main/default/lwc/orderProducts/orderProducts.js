import { LightningElement,wire,api} from 'lwc';
import { getRecord,getRecordNotifyChange} from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import PRICEBOOKREC_ID from '@salesforce/schema/Order.Pricebook2Id';
import orderProductsData from '@salesforce/apex/OrderProductsController.getOrderProducts';
import error_Message from '@salesforce/label/c.Error_Message';
import {
    subscribe,
    unsubscribe,
    APPLICATION_SCOPE,
    MessageContext
} from 'lightning/messageService';
import productsAddedEvent from '@salesforce/messageChannel/productsAddedEvent__c';

const columns = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Unit Price',fieldName: 'UnitPrice'},
    { label: 'Quantity',fieldName: 'Quantity'},
    { label: 'Total Price',fieldName: 'TotalPrice'}
];
export default class OrderProducts extends LightningElement {	
    @api recordId;	
	/** View controller attributes */
	showTable=true;    
    /** Custom Labels */
    labels = {
        error_Message
    }
    /** dataTable controller attributes */
	columns;
	productData =[];	
	/** Massage controller attributes*/
	receivedMessage;
	subscription = null;
	/** to listen the product added method */
    @wire(MessageContext)
    messageContext;
	/** to Subscribe the product added method */
    subscribeToMessageChannel() {		
        if (!this.subscription) {
            this.subscription = subscribe(
                this.messageContext,
                productsAddedEvent,
                (message) => this.handleMessage(message),
                { scope: APPLICATION_SCOPE }
            );
        }
    }	
    unsubscribeToMessageChannel() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }	
    handleMessage(message) {
        this.recordId = message.recordId;
        this.receivedMessage = message ? JSON.stringify( message, null, '\t' ) : 'no message payload';
    }	
    connectedCallback() {
        this.subscribeToMessageChannel();
    }	
    disconnectedCallback() {
        this.unsubscribeToMessageChannel();
    }
	/**to get the current orders data */ 
    @wire(getRecord, { recordId: '$recordId', fields: [PRICEBOOKREC_ID] })
    orderRecordData({ error, data }){
		try {
			if(data){				
				this.PRICEBOOKREC_ID =data.fields.Pricebook2Id.value;				
				if (this.PRICEBOOKREC_ID) {
					/** to get the Order Product associated to the order */
					orderProductsData({
						orderId: this.recordId
					})
					.then (result => {		
                        console.log('backendData:'+JSON.stringify(result));			  
						this.showTable=true;
						this.productData=[]; //To update the data from backend
						if(result.length ==0) {
						   this.showTable = false;
						   console.log('Size 0');
						}else{	
                            for (let recdata of result) {
							  this.columns = columns;
							  this.productData.push({   Name:recdata.Product2.Name,
                                                        UnitPrice: recdata.UnitPrice,
                                                        id: recdata.Product2Id,
                                                        Quantity: recdata.Quantity,
                                                        TotalPrice: recdata.TotalPrice
                                                    });
							}
					   }
                       getRecordNotifyChange([{recordId: this.recordId}]);	
					})
					.catch (error => {						
						this.displayMassageEvent('Error',this.labels.error_Message,'error');
						this.showTable = false;
					}); 					
				} else {
					this.showTable = false;
				}
			}
		} catch (error) {
            this.displayMassageEvent('Error',this.labels.error_Message,'error');
		}
    }	
	/** Method to fire the show toast event*/
    displayMassageEvent(title,message,variant){
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