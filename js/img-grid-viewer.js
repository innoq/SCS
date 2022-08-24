class ImageGridLink extends HTMLElement {
  connectedCallback() {
    this.link = this.querySelector('a')
    this.imageGrid = this.parentElement

    this.linkClickListener = ev => {
      ev.stopImmediatePropagation()
      ev.preventDefault()

      this.open()
      return false;
    }
  }

  disconnectedCallback() {
      this.link?.removeEventListener('click', this.linkClickListener)
  }

  open() {
    this.dispatchEvent(new CustomEvent('img-grid:open', {
      bubbles: true
    }))
  }

  get before() {
    return this._before
  }

  set before(itemLink) {
    this._before = itemLink
  }

  get after() {
    return this._after
  }

  set after(itemLink) {
    this._after = itemLink
  }

  connect(before, after) {
    this.before = before
    this.after = after
    this.classList.add('connected')
    this.link?.addEventListener('click', this.linkClickListener)
  }
}

class ImageGridViewLayer extends HTMLElement {
  connectedCallback() {
    this.closeButton = closeButtonElement()
    this.prevButton = browseButtonElement('previous', 'previous-image')
    this.nextButton = browseButtonElement('next', 'next-image')

    this.closeButtonClickListener = () => this.close()
    this.nextButtonClickListener = () => this.next()
    this.prevButtonClickListener = () => this.prev()

    this.closeButton?.addEventListener('click', this.closeButtonClickListener)
    this.prevButton?.addEventListener('click', this.prevButtonClickListener)
    this.nextButton?.addEventListener('click', this.nextButtonClickListener)

    this.prepend(this.prevButton, this.nextButton, this.closeButton)
  }

  show(imageLink) {
    this.current = imageLink
    this.style.setProperty('--background-image', `url(${this.current.link?.href})`)
    this.open()
  }

  open() {
    this.outerGridClickListener = ev => this.outerGridClick(ev)
    document.addEventListener('click', this.outerGridClickListener)
    this.classList.remove('closed')
  }

  close() {
    if (this.outerGridClickListener){
      document.removeEventListener('click', this.outerGridClickListener)
    }
    this.classList.add('closed')
  }

  outerGridClick(event) {
    if (!this.contains(event.target)) {
      this.close()
    }
  }

  next() {
    this.show(this.current?.after)
  }

  prev() {
    this.show(this.current?.before)
  }

  get isOpen() {
    return !this.classList.contains('closed')
  }
}


class ImageGridViewer extends HTMLElement {
  connectedCallback() {
    this.viewLayer = viewLayerElement()
    this.prepend(this.viewLayer)
    this.imageLinks = Array.from(this.querySelectorAll('img-grid-link'))

    this.imageLinks.forEach((l, idx) => {
      const before = this.imageLinks[idx - 1 < 0 ? (this.imageLinks.length - 1) : idx - 1]
      const after = this.imageLinks[idx + 1 <= this.imageLinks.length -1 ?  idx + 1 : 0]
      l.connect(before , after)
    })

    this.imageLinkOpenListener = (ev) => {
      ev.stopImmediatePropagation()
      const {target: imageLink } = ev
      this.viewLayer.isOpen ?
        this.viewLayer.close() // the layer is open already and somebody clicked a slide behind the back of the viewer
        : this.open(imageLink)
    }

    this.addEventListener('img-grid:open', this.imageLinkOpenListener)
  }

  disconnectedCallback() {
    this.removeEventListener('img-grid:open', this.imageLinkOpenListener)
  }

  open(imageLink) {
    this.viewLayer?.show(imageLink)
  }
}

customElements.define('img-grid-link', ImageGridLink)
customElements.define('img-grid-viewer', ImageGridViewer)
customElements.define('img-grid-view-layer', ImageGridViewLayer)


function viewLayerElement() {
  return domElement(`
    <img-grid-view-layer class="closed"></img-grid-view-layer>
  `)
}

function closeButtonElement() {
  return domElement(`
    <button type="button" class="img-grid-close-button">close</button>
  `)
}

function browseButtonElement (text, cls) {
  return domElement(`
    <button type="button" class="img-grid-browse-button ${cls}">${text}</button>
  `)
}

function domElement(str) {
  const parser = new DOMParser()
  const doc = parser.parseFromString(str, 'text/html')
  return doc.body.firstChild
}
