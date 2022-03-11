import { LightningElement, track,wire,api } from 'lwc';
import { getRecord,getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ORDERSTATUS from '@salesforce/schema/Order.Status';
import PRICEBOOK_ID from '@salesforce/schema/Order.Pricebook2Id';
import orderConfirmationProcess from '@salesforce/apex/OrderConfirmationServerSideController.confirmOrder';
import error_Message from '@salesforce/label/c.Error_Message';
import orderConfirmed from '@salesforce/label/c.OrderConfirmed';


export default class orderConfirmation extends LightningElement {
	
    @api recordId;
	/** View controller attributes */
    @track showTable = true;

    /** Custom Labels */
    labels = {
        error_Message,
        orderConfirmed
    }
	
	/**to get the current orders data */  
    @wire(getRecord, { recordId: '$recordId', fields: [PRICEBOOK_ID,ORDERSTATUS] })
    orderData({ error, data }){
		
        if(data){
			/**to verify the order status */
            this.ORDERSTATUS =data.fields.Status.value;
            this.PRICEBOOK_ID =data.fields.Pricebook2Id.value;
            if(this.ORDERSTATUS == 'Activated') {
                this.showTable = false;
            }
            if(!this.PRICEBOOK_ID ){
                this.showTable = false;
            }
        }
    }
	
	/** to perform backend operation on button click*/
    confirmOrder() {
		/** to perform backend operation*/
        orderConfirmationProcess ({
            orderId: this.recordId
        })
        .then(result => {
			
            if (result.includes('Successfully')){
               
				getRecordNotifyChange([{recordId: this.recordId}]);
				this.ShowToastEvent('Successful',this.labels.orderConfirmed);

            }else {
                this.ShowToastEvent('Error',this.labels.error_Message,'error');
            }
        })
        .catch (error => { 
		
            this.ShowToastEvent('Error',this.labels.error_Message,'error');
		   
        });
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