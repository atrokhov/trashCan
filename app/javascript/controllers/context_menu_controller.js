import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "item"]
  static values = { selectedId: String }

  connect() {
    this.hideMenu()
    document.addEventListener('click', this.hideMenu.bind(this))
  }

  show(event) {
    event.preventDefault()
    
    console.log(event.pageX, event.pageY)
    this.menuTarget.style.top = `${event.pageY}px`
    this.menuTarget.style.left = `${event.pageX}px`
    
    // Определяем тип меню
    const isItem = event.target.closest('[data-context-item]')
    
    if (isItem) {
      // Меню для элемента
      this.menuTarget.innerHTML = this.itemMenuContent()
      this.selectedIdValue = isItem.dataset.contextItem
    } else {
      // Меню для фона
      this.menuTarget.innerHTML = this.backgroundMenuContent()
    }
    
    // Показываем меню
    this.menuTarget.classList.remove('hidden')
  }

  hideMenu(event) {
    if (!event || !this.menuTarget.contains(event.target)) {
      this.menuTarget.classList.add('hidden')
    }
  }

  backgroundMenuContent() {
    return `
      <div class="py-1">
        <button data-action="click->context-menu#createFile" class="menu-item">
          <i class="material-icons mr-2">note_add</i>Создать текстовый файл
        </button>
        <button data-action="click->context-menu#createFolder" class="menu-item">
          <i class="material-icons mr-2">create_new_folder</i>Создать папку
        </button>
        <button data-action="click->context-menu#showProperties" class="menu-item">
          <i class="material-icons mr-2">info</i>Свойства
        </button>
      </div>
    `
  }

  itemMenuContent() {
    return `
      <div class="py-1">
        <button data-action="click->context-menu#renameItem" class="menu-item">
          <i class="material-icons mr-2">drive_file_rename_outline</i>Переименовать
        </button>
        <button data-action="click->context-menu#deleteItem" class="menu-item text-red-600">
          <i class="material-icons mr-2">delete</i>Удалить
        </button>
        <button data-action="click->context-menu#showProperties" class="menu-item">
          <i class="material-icons mr-2">info</i>Свойства
        </button>
      </div>
    `
  }

  // Действия меню
  createFile() {
    console.log("Создание файла...")
    this.hideMenu()
    // Ваша логика здесь
  }

  createFolder() {
    console.log("Создание папки...")
    this.hideMenu()
  }

  renameItem() {
    console.log(`Переименование элемента: ${this.selectedIdValue}`)
    this.hideMenu()
  }

  deleteItem() {
    console.log(`Удаление элемента: ${this.selectedIdValue}`)
    this.hideMenu()
  }

  showProperties() {
    console.log("Свойства...")
    this.hideMenu()
  }
}