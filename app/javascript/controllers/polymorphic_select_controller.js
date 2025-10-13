// app/javascript/controllers/polymorphic_select_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["typeSelect", "storeSelect", "warehouseSelect"]

    connect() {
        // Al cargar la página (ej. en edición), mostrar el select correcto
        this.toggle()
    }

    toggle() {
        const selectedType = this.typeSelectTarget.value

        if (selectedType === "Store") {
            this.show(this.storeSelectTarget)
            this.hide(this.warehouseSelectTarget)
            this.enableSelect(this.storeSelectTarget.querySelector("select"))
            this.disableSelect(this.warehouseSelectTarget.querySelector("select"))
        } else if (selectedType === "Warehouse") {
            this.show(this.warehouseSelectTarget)
            this.hide(this.storeSelectTarget)
            this.enableSelect(this.warehouseSelectTarget.querySelector("select"))
            this.disableSelect(this.storeSelectTarget.querySelector("select"))
        } else {
            this.hide(this.storeSelectTarget)
            this.hide(this.warehouseSelectTarget)
            this.disableSelect(this.storeSelectTarget.querySelector("select"))
            this.disableSelect(this.warehouseSelectTarget.querySelector("select"))
        }
    }

    show(element) {
        element.classList.remove("hidden")
        element.style.display = "block"
    }

    hide(element) {
        element.classList.add("hidden")
        element.style.display = "none"
    }

    enableSelect(select) {
        if (select) select.disabled = false
    }

    disableSelect(select) {
        if (select) select.disabled = true
    }
}