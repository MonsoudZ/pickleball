import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "panel"]

  connect() {
    this.show(this.buttonTargets[0]?.dataset.tabId)
  }

  switch(event) {
    this.show(event.currentTarget.dataset.tabId)
  }

  show(activeId) {
    if (!activeId) return

    this.buttonTargets.forEach((button) => {
      const isActive = button.dataset.tabId === activeId
      button.classList.toggle("bg-emerald-700", isActive)
      button.classList.toggle("text-white", isActive)
      button.classList.toggle("border-emerald-700", isActive)
      button.classList.toggle("text-slate-700", !isActive)
      button.classList.toggle("bg-white", !isActive)
      button.classList.toggle("border-slate-300", !isActive)
    })

    this.panelTargets.forEach((panel) => {
      panel.classList.toggle("hidden", panel.dataset.tabId !== activeId)
    })
  }
}
