import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["input", "dropzone", "items", "progress", "progressBar", "progressText", "status"]
  static values = { 
    url: String,
    room: String,
    total: Number,
    processed: Number
  }

  connect() {
    this.setupDropzone()
    this.processedValue = 0
    this.subscribeToChannel()
  }

  setupDropzone() {
    this.dropzoneTarget.addEventListener("dragover", (e) => {
      e.preventDefault()
      this.dropzoneTarget.classList.add("bg-blue-50", "border-blue-400")
    })

    this.dropzoneTarget.addEventListener("dragleave", () => {
      this.dropzoneTarget.classList.remove("bg-blue-50", "border-blue-400")
    })

    this.dropzoneTarget.addEventListener("drop", (e) => {
      e.preventDefault()
      this.dropzoneTarget.classList.remove("bg-blue-50", "border-blue-400")
      
      if (e.dataTransfer.files.length) {
        this.uploadFiles(e.dataTransfer.files)
      }
    })
  }

  openFileDialog() {
    this.inputTarget.click()
  }

  onFileSelect(e) {
    if (e.target.files.length) {
      this.uploadFiles(e.target.files)
    }
  }

  uploadFiles(files) {
    this.totalValue = files.length
    this.processedValue = 0
    this.showProgress()
    this.updateProgress()

    const formData = new FormData()
    
    Array.from(files).forEach((file, i) => {
      formData.append("files[]", file)
    })

    console.log("Elem:", this.urlValue, "Files:", files.length)

    fetch(this.urlValue, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => response.json())
    .then(data => {
      this.roomValue = data.room
      this.statusTarget.textContent = "Обработка файлов..."
    })
    .catch(error => {
      console.error("Ошибка загрузки:", error)
      this.statusTarget.textContent = "Ошибка загрузки!"
      this.hideProgress(5000)
    })
  }

  subscribeToChannel() {
    this.channel = consumer.subscriptions.create(
      { 
        channel: "UploadProgressChannel", 
        room: this.roomValue 
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this)
      }
    )
  }

  _connected() {
    console.log("Подключено к каналу загрузки")
  }

  _disconnected() {
    console.log("Отключено от канала загрузки")
  }

  _received(data) {
    switch(data.type) {
      case "file_processed":
        this.itemsTarget.insertAdjacentHTML("beforeend", data.html)
        this.processedValue += 1
        this.updateProgress()
        break;
      case "error":
        console.error(data.message)
        this.processedValue += 1
        this.updateProgress()
        break;
    }
  }

  showProgress() {
    this.progressTarget.classList.remove("hidden")
    this.progressBarTarget.style.width = "0%"
    this.progressTextTarget.textContent = "0%"
    this.statusTarget.textContent = "Начало загрузки..."
  }

  updateProgress() {
    const percent = Math.round((this.processedValue / this.totalValue) * 100)
    this.progressBarTarget.style.width = `${percent}%`
    this.progressTextTarget.textContent = `${percent}%`
    this.statusTarget.textContent = `Обработано ${this.processedValue} из ${this.totalValue} файлов`

    if (this.processedValue === this.totalValue) {
      this.statusTarget.textContent = "Все файлы обработаны!"
      this.hideProgress(2000)
    }
  }

  hideProgress(delay = 0) {
    setTimeout(() => {
      this.progressTarget.classList.add("hidden")
    }, delay)
  }
}