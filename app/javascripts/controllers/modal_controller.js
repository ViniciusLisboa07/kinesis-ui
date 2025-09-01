import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "backdrop"]
  static values = { 
    closeOnBackdrop: { type: Boolean, default: true },
    closeOnEscape: { type: Boolean, default: true }
  }

  connect() {
    this.handleKeydown = this.handleKeydown.bind(this)
    this.handleBackdropClick = this.handleBackdropClick.bind(this)
  }

  open(event) {
    if (event) event.preventDefault()
    
    this.contentTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
    
    if (this.closeOnEscapeValue) {
      document.addEventListener("keydown", this.handleKeydown)
    }
    
    // Focus trap - opcional
    this.trapFocus()
    
    // Dispatch custom event
    this.dispatch("opened")
  }

  close(event) {
    if (event) event.preventDefault()
    
    this.contentTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    
    document.removeEventListener("keydown", this.handleKeydown)
    
    // Dispatch custom event
    this.dispatch("closed")
  }

  confirm(event) {
    if (event) event.preventDefault()
    
    // Dispatch custom event with data
    this.dispatch("confirmed")
    
    // Close modal after confirmation
    this.close()
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  handleBackdropClick(event) {
    if (this.closeOnBackdropValue && event.target === this.contentTarget) {
      this.close()
    }
  }

  trapFocus() {
    const focusableElements = this.contentTarget.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )
    
    if (focusableElements.length > 0) {
      focusableElements[0].focus()
    }
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleKeydown)
    document.body.classList.remove("overflow-hidden")
  }
}