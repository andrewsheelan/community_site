import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scrollToBottom()
    this.setupMutationObserver()
  }

  disconnect() {
    if (this.mutationObserver) {
      this.mutationObserver.disconnect()
    }
  }

  scrollToBottom() {
    this.element.scrollTop = this.element.scrollHeight
  }

  setupMutationObserver() {
    this.mutationObserver = new MutationObserver(this.scrollToBottom.bind(this))
    this.mutationObserver.observe(this.element, {
      childList: true,
      subtree: true
    })
  }
}
