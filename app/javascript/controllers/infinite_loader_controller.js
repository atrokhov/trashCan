import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "loader"]
  static values = { 
    url: String,
    page: { type: Number, default: 1 },
    loading: { type: Boolean, default: false },
    lastPage: { type: Boolean, default: false }
  }

  initialize() {
    this.scrollHandler = this._handleScroll.bind(this)
  }

  connect() {
    window.addEventListener('scroll', this.scrollHandler)
    this._checkLoadMore()
  }

  disconnect() {
    window.removeEventListener('scroll', this.scrollHandler)
  }

  loadMore() {
    if (this.loadingValue || this.lastPageValue) return
    
    this.loadingValue = true
    this.loaderTarget.classList.remove('hidden')
    
    const nextPage = this.pageValue + 1
    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set('page', nextPage)

    fetch(url, {
      headers: { Accept: 'text/vnd.turbo-stream.html' }
    })
    .then(response => {
      if (!response.ok) throw new Error("Network response was not ok")
      return response.text()
    })
    .then(html => {
      if (html.trim() === '') {
        this.lastPageValue = true
      } else {
        Turbo.renderStreamMessage(html)
        this.pageValue = nextPage
      }
    })
    .catch(error => {
      console.error('Error loading more items:', error)
    })
    .finally(() => {
      this.loadingValue = false
      this.loaderTarget.classList.add('hidden')
    })
  }

  _handleScroll() {
    if (this.loadingValue || this.lastPageValue) return
    this._checkLoadMore()
  }

  _checkLoadMore() {
    const loaderPosition = this.loaderTarget.getBoundingClientRect()
    const triggerPoint = window.innerHeight * 0.9
    
    if (loaderPosition.top <= triggerPoint && loaderPosition.bottom >= 0) {
      this.loadMore()
    }
  }
}