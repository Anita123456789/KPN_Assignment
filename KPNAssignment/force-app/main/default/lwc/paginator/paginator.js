import { LightningElement } from 'lwc';

export default class Paginator extends LightningElement {
    previousButtonHandler() {
        this.dispatchEvent(new CustomEvent('previous'));
    }

    nextButtonHandler() {
        this.dispatchEvent(new CustomEvent('next'));
    }
}