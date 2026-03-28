import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  openAt(event) {
    this.positionNear(event)
    this.show()
  }

  openFromFrame() {
    this.show()
  }

  close() {
    this.panelTarget.classList.add("hidden")
  }

  closeOnOutside(event) {
    if (this.panelTarget.classList.contains("hidden")) {
      return
    }

    if (this.panelTarget.contains(event.target)) {
      return
    }

    if (event.target.closest("[data-session-popover-trigger='true']")) {
      return
    }

    this.close()
  }

  positionNear(event) {
    const panel = this.panelTarget
    panel.classList.remove("hidden")

    const panelWidth = 360
    const panelHeight = 420
    const margin = 12

    let left = event.clientX + margin
    let top = event.clientY - 40

    if (left + panelWidth > window.innerWidth - margin) {
      left = window.innerWidth - panelWidth - margin
    }

    if (top + panelHeight > window.innerHeight - margin) {
      top = window.innerHeight - panelHeight - margin
    }

    if (top < margin) {
      top = margin
    }

    panel.style.left = `${left}px`
    panel.style.top = `${top}px`
  }

  show() {
    this.panelTarget.classList.remove("hidden")
  }
}
