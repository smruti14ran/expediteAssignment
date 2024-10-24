import { LightningElement } from 'lwc';
//import MY_HTML_FILE from '@salesforce/resourceUrl/angularLib';
import MY_HTML_FILE from '@salesforce/resourceUrl/demo';

export default class MyComponent extends LightningElement {
    htmlPath = MY_HTML_FILE + '/index.html';
    isHtmlLoaded = false;

    renderedCallback() {
        if (!this.isHtmlLoaded) {
            this.isHtmlLoaded = true;

            // Fetch and insert the Angular app's HTML
            fetch(this.htmlPath)  // Use `this.htmlPath` to access the variable
                .then(response => {
                    if (!response.ok) {
                        throw new Error(`HTTP error! status: ${response.status}`);
                    }
                    return response.text();
                })
                .then(html => {
                    this.template.querySelector('.html-container').innerHTML = html;
                    
                //     // Load necessary CSS files
                //     const link = document.createElement('link');
                //     link.rel = 'stylesheet';
                //     link.href = '${MY_HTML_FILE}/styles-SPGCUN26.css';  // Use backticks
                //     document.head.appendChild(link);

                //     // Load necessary JavaScript files
                //     const polyfillsScript = document.createElement('script');
                //     polyfillsScript.src = '${MY_HTML_FILE}/polyfills-EJ46DL77.js';  // Use backticks
                //     polyfillsScript.onload = () => {
                //         const mainScript = document.createElement('script');
                //         mainScript.src = '${MY_HTML_FILE}/main-CR4TNG22.js';  // Use backticks
                //         document.body.appendChild(mainScript);
                //     };
                //     document.body.appendChild(polyfillsScript);
                })
                 .catch(error => {
                    console.error('Error loading Angular app', error);
                 });
        }
    }
}
