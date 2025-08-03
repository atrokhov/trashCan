import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["active"]
  static targets = ["container"]

  connect() {
    this.documentClickHandler = (event) => {
      if (!this.element.contains(event.target)) {
        this.hide()
      }
    }
  }

  toggle() {
    if (this.element.classList.contains(this.activeClass)) {
      this.hide()
    } else {
      this.show()
    }
  }

  show() {
    this.element.classList.add(this.activeClass)
    this.element.querySelector('.item-name').classList.remove('max-w-[10ch]')
    this.element.querySelector('.item-name').classList.remove('truncate')
    document.addEventListener('click', this.documentClickHandler)
  }

  hide() {
    this.element.classList.remove(this.activeClass)
    this.element.querySelector('.item-name').classList.add('max-w-[10ch]')
    this.element.querySelector('.item-name').classList.add('truncate')
    document.removeEventListener('click', this.documentClickHandler)
  }

  disconnect() {
    this.hide()
  }
}