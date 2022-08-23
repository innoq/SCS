export default class TouchDetection extends HTMLElement {
    connectedCallback () {
      window.addEventListener('touchstart', function touched () {
        document.body.classList.add('instructions--touch-active')
        window.removeEventListener('touchstart', touched, false)
      }, false)
    }
  }

  customElements.define('touch-detection', TouchDetection)
  