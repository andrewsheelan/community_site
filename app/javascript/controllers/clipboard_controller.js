import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value).then(() => {
      // You could add a toast notification here
      console.log("Copied to clipboard!")
    })
  }
}
