import { LightningElement,api,track,wire } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getOrderLineItems from '@salesforce/apex/InvoiceGeneratorController.getOrderLineItems';
import createInvoices from '@salesforce/apex/InvoiceGeneratorController.createInvoices';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

const columns = [
    { label: ' Product/Service # ', fieldName: 'OrderItemNumber' },
    { label: ' Product/Service Name ', fieldName: 'productName' },
    { label: 'Activation Date', fieldName: 'Activation_Date__c', type: 'date-local',editable: true }
];

export default class InvoiceGeneration  extends NavigationMixin(LightningElement) {
    @api recordId;
    @track orderLineData = [];
    columns = columns;
    allSelected = false;
    
    
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.state.recordId;
        }
    }

    connectedCallback(){
        console.log('recordId '+this.recordId);
        getOrderLineItems({orderId : this.recordId})
        .then(result =>{
            //this.orderLineData = result;
            this.orderLineData = result.map(value=>{
                return{...value,productName:value.Product2.Name,isChecked:false}
            });

            console.log(JSON.stringify(this.orderLineData));
        })
        .catch(error =>{
            console.log('something went wrong');
        })
    }

    handleSelectAll(event) {
        this.allSelected = event.target.checked;
        let checkboxes =  this.template.querySelectorAll('[data-label="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.checked = this.allSelected;
        });
        this.orderLineData.forEach(element => {
            element.isChecked = this.allSelected;
        });
    }

    handleRowSelection(event) {
        const selectedRowId = event.target.dataset.id;
        //const selectedRow = this.orderLineData.find(row => row.Id === selectedRowId);
        this.orderLineData.forEach(element => {
            if(element.Id === selectedRowId){
                element.isChecked = event.target.checked;
            }
            console.log('selected row '+JSON.stringify(element));
        });
    }

    handleActivationDate(event){
        const selectedRecordId = event.target.id.split('-')[0];
        const activationDate = event.target.value;
        this.orderLineData.forEach(element => {
            if(element.Id === selectedRecordId){
                element.Activation_Date__c = activationDate
            }
        });
    }

    handleSave(event){
        var invoiceFields = {};
        var oliToActivationDateMap = [];
        //checking for validation of activation date
        this.orderLineData.forEach(element => {
            if(element.isChecked && (element.Activation_Date__c != undefined || element.Activation_Date__c != '')){
                oliToActivationDateMap.push({orderLineId: element.Id, activationDate : element.Activation_Date__c});
            }
           if(element.isChecked && (element.Activation_Date__c == undefined || element.Activation_Date__c == '') ){
                this.showToast("Error","Please provide Activation Date for the product selected", "error" );
                return;
            } 
        });
        console.log(oliToActivationDateMap);
        createInvoices({orderId : this.recordId , activationDateInfo :JSON.stringify(oliToActivationDateMap)  })
        .then(result => {
            let invoiceId = result;
            this.showToast("Success","Invoice created successfully", "success" );
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    objectApiName: 'Invoice__c',
                    actionName: 'view',
                    recordId: invoiceId
                }
            })
        })
        .catch(error => {
            this.showToast("Error","Something went wrong. Please contact system admin", "error" );
        })

        
    }

    showToast(title, message, variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}