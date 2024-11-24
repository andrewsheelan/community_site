import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "arrow", "messages", "input"]

  connect() {
    this.scrollToBottom()
  }

  toggle() {
    this.contentTarget.classList.toggle("hidden")
    this.arrowTarget.classList.toggle("rotate-180")
    this.scrollToBottom()
  }

  scrollToBottom() {
    if (this.hasMessagesTarget) {
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  async submitMessage(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)

    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        // Clear the input
        this.inputTarget.value = ""
        
        // Refresh messages (you might want to use Action Cable for real-time updates)
        location.reload()
      }
    } catch (error) {
      console.error("Error sending message:", error)
    }
  }
}
