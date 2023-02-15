import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["items","menufondo"]

  toggle() {
    this.itemsTarget.classList.toggle('d-none')
    this.menuFondoTarget.classList.toggle('d-none')
  }
}
