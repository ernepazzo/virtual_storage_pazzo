import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["header","footer","main"]

  connect() {
    let header = this.headerTarget.clientHeight;
    let footer = this.footerTarget.clientHeight;

    const minH = `calc(100vh - ${header + footer}px)`;

    this.mainTarget.style.minHeight = minH;
  }

  reajustar_tamanno() {    
    let header = this.headerTarget.clientHeight;
    let footer = this.footerTarget.clientHeight;

    const minH = `calc(100vh - ${header + footer}px)`;

    this.mainTarget.style.minHeight = minH;
  }
}
