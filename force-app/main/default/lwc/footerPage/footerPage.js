import { LightningElement } from 'lwc';
import { loadScript,loadStyle } from 'lightning/platformResourceLoader';
import BootLib from '@salesforce/resourceUrl/BootstrapLib';

export default class FooterPage extends LightningElement {

    renderedCallback(){
        Promise.all([
            loadStyle(this, BootLib + '/bootstrap-4.0.0/dist/css/bootstrap.min.css'),
        ])
    .then(() => {
                
            })
            .catch(error => {
                alert(error.body.message);
            });
    }
}