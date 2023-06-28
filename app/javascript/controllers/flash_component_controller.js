import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  closeFlash(e) {
    e.target.parentElement.style.display = "none"
  }
}