import { LightningElement } from 'lwc';
import image1 from '@salesforce/resourceUrl/Prod1'; // Replace with actual resource URL
import image2 from '@salesforce/resourceUrl/Prod2'; // Replace with actual resource URL
import image3 from '@salesforce/resourceUrl/Prod3';
import image4 from '@salesforce/resourceUrl/Prod4'; // Replace with actual resource URL
import image5 from '@salesforce/resourceUrl/Prod5'; // Replace with actual resource URL
import image6 from '@salesforce/resourceUrl/Prod6';
import BootLib from '@salesforce/resourceUrl/BootstrapLib';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import { loadScript,loadStyle } from 'lightning/platformResourceLoader';
export default class ProductSalePage extends LightningElement {
    slide1 = false;
    slide2 = false;
    slide3 = false;
    buttonClicked = false;

   image1 = image1;
   image2 = image2;
   image3 = image3;
   image4 = image4;
   image5 = image5;
   image6 = image6;


    renderedCallback() {
        Promise.all([
            loadStyle(this, BootLib + '/bootstrap-4.0.0/dist/css/bootstrap.min.css'),
        ])
    .then(() => {
                
            })
            .catch(error => {
                alert(error.body.message);
            });
    }


    handleBuy(){
        console.log('button clicked');
        const evt = new ShowToastEvent({
            title: 'Congrats !',
            message: 'Product has been successfully bought.',
            variant: 'success'
        });
        this.dispatchEvent(evt);
    }

}