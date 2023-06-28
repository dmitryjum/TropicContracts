import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['container', 'fileLabel']

  submit() {
    const label = this.fileLabelTarget
    label.innerHTML = '<p class="text-gray-800 text-md mt-3">File is being uploaded....</p>'
  }

  fileAdded(e) {
    const fileName = e.target.files[0]["name"]
    const nameP = document.createElement("p");
    nameP.classList.add("text-gray-800", "text-md", "mt-3");
    nameP.textContent = fileName
    const label = this.fileLabelTarget

    label.after(nameP)
  }

  handleSuccess({ detail: { success } }) {
    if (success) {
      const modalContainer = this.containerTarget
      modalContainer.className = "hidden"
    }
  }
  
  closeModal() {
    const modalContainer = this.containerTarget
    modalContainer.className = "hidden"
  }
}