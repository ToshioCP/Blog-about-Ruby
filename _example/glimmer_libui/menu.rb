require 'glimmer-dsl-libui'

include Glimmer

menu('File') {
  menu_item('Open') {
    on_clicked do
      file =  open_file
      @label.text = File.read(file)
    end
  }
  quit_menu_item
}

window('Menu', 800,600) {
  @label = label('')
}.show
