import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
    connect() {
        this.modal = new bootstrap.Modal(this.element, {
            keyboard: false,
            backdrop: 'static',
            focus: true
        })
        this.modal.show();
    }

    disconnect() {
        this.modal.hide();
    }
}
