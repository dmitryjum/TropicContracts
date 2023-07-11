import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const flashElement = this.element
    if (flashElement.classList[0] === "notice") {
      setTimeout(() => {
        flashElement.style.display = "none"
      }, 4000)
    }
  }

  closeFlash(e) {
    e.target.parentElement.style.display = "none"
  }
}