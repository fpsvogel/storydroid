import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="story-form"
export default class extends Controller {
  static targets = ["textArea"];

  connect() {
    console.log('story-form controller connected...');
    this.textAreaTarget.style.resize = 'none';
    this.textAreaTarget.style.minHeight = `${this.textAreaTarget.scrollHeight}px`;
    this.textAreaTarget.style.overflow = 'hidden';
  }

  resizeTextArea(event) {
    event.target.style.height = '5px';
    event.target.style.height =  `${event.target.scrollHeight}px`;
  }
}
