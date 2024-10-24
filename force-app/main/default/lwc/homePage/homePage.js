// slideshow.js
import { LightningElement } from 'lwc';
import image1 from '@salesforce/resourceUrl/Prod1'; // Replace with actual resource URL
import image2 from '@salesforce/resourceUrl/Prod2'; // Replace with actual resource URL
import image3 from '@salesforce/resourceUrl/Prod3';
export default class Slideshow extends LightningElement {
    slide1 = false;
    slide2 = false;
    slide3 = false;
    buttonClicked = false;

    slides = [
        { id: 1, number: '1 / 3', src: image1, caption: 'SuperGIG™ Flat Panel Ku-Band Antenna', cssClass: 'mySlides', dotClass: 'dot',displaySepc :true },
        { id: 2, number: '2 / 3', src: image2, caption: 'OW11FV', cssClass: 'mySlides', dotClass: 'dot',displaySepc :true },
        { id: 3, number: '3 / 3', src: image3, caption: 'GateWay 211', cssClass: 'mySlides', dotClass: 'dot',displaySepc :true }
    ];

    selectedSlideIndex = 1;

    renderedCallback() {
        this.showSlides(this.selectedSlideIndex);
    }

    previousSlide() {
        this.showSlides(this.selectedSlideIndex - 1);
    }

    nextSlide() {
        this.showSlides(this.selectedSlideIndex + 1);
    }

    selectSlide(event) {
        this.showSlides(parseInt(event.target.dataset.id, 10));
    }

    showSlides(n) {
        if(n==1){
            this.slide1 = true;
            this.slide2 = false;
            this.slide3 = false;
        }
        else if(n==2){
            this.slide1 = false;
            this.slide2 = true;
            this.slide3 = false;
        }
        else if(n==3){
            this.slide1 = false;
            this.slide2 = false;
            this.slide3 = true;
        }
        let i;
        const slides = this.template.querySelectorAll('.mySlides');
        const dots = this.template.querySelectorAll('.dot');
        if (n > slides.length) { n = 1; }
        if (n < 1) { n = slides.length; }
        this.selectedSlideIndex = n;
        slides.forEach(slide => {
            slide.style.display = "none";
        });
        dots.forEach(dot => {
            dot.classList.remove("active");
        });
        slides[n - 1].style.display = "block";
        dots[n - 1].classList.add("active");
    /*    setTimeout(() => {
            this.showSlides(n+1);
        }, 3000); */
    }

    handleUsageClick(event){
        console.log('button clicked');
        this.buttonClicked = true;
    }

    closeModal(){
        this.buttonClicked = false;
    }
}