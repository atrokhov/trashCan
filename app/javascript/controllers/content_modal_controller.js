import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="content-modal"
export default class extends Controller {
  static values = {
    url: String,
    mimeType: String,
    extension: String
  }

  connect() {
    this.element.addEventListener('dblclick', this.openModal.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('dblclick', this.openModal)
  }

  async openModal() {
    if (this.detectFileType(this.mimeTypeValue) === 'folder'){
      window.location.href = this.urlValue
      return
    }
    
    const content = await this.generateContent()
    this.showModal(content)
  }

  async generateContent() {
    const url = this.urlValue
    const type = this.detectFileType(this.mimeTypeValue)

    switch(type) {
      case 'video':
        return `
          <video controls autoplay class="w-full">
            <source src="${url}" type="video/mp4">
            <source src="${url}" type="video/webm">
            Ваш браузер не поддерживает видео.
          </video>
        `
      case 'image':
        return `<img src="${url}" class="max-h-[80vh] mx-auto">`
      case 'audio':
        return `
          <audio controls class="w-full">
            <source src="${url}" type="audio/mpeg">
            <source src="${url}" type="audio/ogg">
            Ваш браузер не поддерживает аудио.
          </audio>
        `
      case 'pdf':
        return `<iframe src="${url}" class="w-full h-[80vh]"></iframe>`
      case 'text':
        return await this.textContent(this.extensionValue, url)
      case 'application':
        return await this.textContent(this.extensionValue, url)
      case 'font':
        return `
          <div class="text-center p-8">
            <p class="text-lg mb-2">Файл шрифта</p>
            <a href="${url}" download class="text-blue-500 underline">Скачать</a>
          </div>
        `
      default:
        return `<p>Неподдерживаемый тип файла: ${type}</p>`
    }
  }

  detectFileType(mime) {
    const type = mime.split('/')[0]
    if (mime === 'application/pdf') return 'pdf'
    if (type) return type
    return 'unknown'
  }

  showModal(content) {
    const modal = document.createElement('div')
    modal.classList.add('fixed', 'inset-0', 'bg-black', 'bg-opacity-75', 'z-50', 'flex', 'items-center', 'justify-center', 'p-4')
    modal.innerHTML = `
      <button class="absolute top-4 right-4 text-gray-500 hover:text-gray-700 z-10">
        <i class="material-icons">close</i>
      </button>
      <div class="bg-white rounded-lg shadow-xl max-w-4xl w-full relative">
        <div class="modal-content p-4">${content}</div>
      </div>
    `
    
    modal.querySelector('button').addEventListener('click', () => modal.remove())
    document.body.appendChild(modal)
    if (window.hljs) hljs.highlightAll();
  }

  async textContent(ext, url) {
    try {
      const response = await fetch(url);
      const text = await response.text();
      console.info(text)
      // Экранирование HTML и сохранение переносов строк
      const escapedText = text
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;')
        .replace(/\n/g, '<br>');

      let langClass = '';
      if (['json', 'xml', 'html', 'css', 'js'].includes(ext)) {
        langClass = `class="language-${ext}"`;

        return `<div class="p-4 max-h-[70vh] overflow-auto">
                  <pre ${langClass}><code class="hljs">${text}</code></pre>
                </div>`;
      } else if (['txt', 'md'].includes(ext)) {
        return `<div class="p-4 max-h-[70vh] overflow-auto bg-gray-50 rounded">
                  <pre class="whitespace-pre-wrap font-mono text-sm">${escapedText}</pre>
                </div>`;
      } else {
        return `<div class="text-center p-8">
                  <p class="text-lg mb-2">Формат не поддерживается</p>
                  <a href="${url}" download class="text-blue-500 underline">Скачать</a>
                </div>`;
      }
    } catch (error) {
      return `<div class="p-4 text-red-500">
        Ошибка загрузки текстового файла: ${error.message}
      </div>`;
    }
  }
}
