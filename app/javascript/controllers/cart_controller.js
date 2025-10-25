import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "cartCount"]

    add(e) {
        console.info('aki estoy')
        e.preventDefault()
        const form = e.target
        const token = document.querySelector('meta[name="csrf-token"]').content

        fetch("/seller/cart", {
            method: "POST", headers: {
                "X-CSRF-Token": token, "Accept": "text/vnd.turbo-stream.html"
            }, body: new FormData(form),
        }).then(response => response.text())
            .then(html => Turbo.renderStreamMessage(html))
    }

    updateQuantity(e) {
        const token = document.querySelector('meta[name="csrf-token"]').content
        fetch(`/seller/cart/${e.target.dataset.id}`, {
            method: "PATCH", headers: {
                "X-CSRF-Token": token, "Accept": "text/vnd.turbo-stream.html"
            }, body: new URLSearchParams({quantity: e.target.value}),
        }).then(response => response.text())
            .then(html => Turbo.renderStreamMessage(html))
    }

    remove(e) {
        console.log('e.target.dataset.id', e.target.dataset.id)
        console.log('cartCount', this.cartCountTarget)
        console.log('cartCount value', this.cartCountTarget.value)
        console.log('cartCount id', this.cartCountTarget.dataset.id)

        // if (e.target.dataset.id !== undefined) {
        const token = document.querySelector('meta[name="csrf-token"]').content
        fetch(`/es/seller/cart/${this.cartCountTarget.dataset.id}`, {
            method: "DELETE", headers: {
                "X-CSRF-Token": token, "Accept": "text/vnd.turbo-stream.html"
            },
        }).then(response => response.text())
            .then(html => Turbo.renderStreamMessage(html))
        // }
    }
}
