import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['container']
  
  close(e) {
    e.preventDefault()
    const modalContainer = this.containerTarget
    modalContainer.className = "hidden"
  }
}