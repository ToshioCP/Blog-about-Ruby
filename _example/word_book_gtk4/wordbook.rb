require "gtk4"
require_relative "db.rb"

# This file contains three objects.
# Class EditWindow < GtkWindow
# GtkApplicationWindow
# GtkApplication

# EditWindow is a composite widget for GtkWindow.
class EditWindow < Gtk::Window
  type_register
  class << self
    def init # this method is called only once when the class is created.
      set_template(:data => GLib::Bytes.new(File.read("edit_window.ui")))
      bind_template_child("entry_en")
      bind_template_child("entry_jp")
      bind_template_child("textview")
    end
  end
  attr_accessor :index
  def record=(record)
    entry_en.text = record[0]
    entry_jp.text = record[1]
    textview.buffer.text = record[2]
  end
  def record
    [entry_en.text, entry_jp.text, textview.buffer.text]
  end
end

# TopWindow is a wrapper for GtkApplicationWindow

# closure for UI data for GtkBuilderListItemFactory 
def nl2sp(listitem, s)
  s.gsub(/\n/," ")
end

class TopWindow
  def initialize(app)
    builder = Gtk::Builder.new(file: "wordbook.ui")
    @window = builder["window"]
    @window.set_application(app)
    search_entry = builder["search_entry"]
    columnview = builder["columnview"]
    custom_filter = builder["filter"]
    @liststore = builder["liststore"]
    columnview.signal_connect("activate") do |_columnview, index|
      edit_window = EditWindow.new
      edit_window.set_application(@window.application)
      edit_window.record = DB.instance.record(index)
      edit_window.index = index
      edit_window.show
    end

    search_entry.signal_connect("activate") do |entry|
      begin
        regexp = Regexp.compile(entry.text)
      rescue RegexpError
        dialog = Gtk::MessageDialog.new(parent: window, flags: :modal, type: :warning, buttons: :ok, message: "正規表現の構文エラー")
        dialog.signal_connect "response" do
          dialog.destroy
        end
        dialog.show
        regexp = // # match any string
      end
      custom_filter.set_filter_func { |wbrecord| regexp =~ wbrecord.to_a[0] }
      custom_filter.changed(:different)
    end
  end
  def window
    @window
  end
  def liststore
    @liststore
  end
end

# GtkApplication

application = Gtk::Application.new("com.github.toshiocp.wordbook", :default_flags)
# action handlers
do_append = lambda do
  edit_window = EditWindow.new
  edit_window.set_application(application)
  edit_window.index = nil
  edit_window.show
end
do_cancel = lambda do
  edit_window = application.active_window
  return unless edit_window.instance_of? EditWindow
  edit_window.destroy
end
do_delete = lambda do
  edit_window = application.active_window
  return unless edit_window.instance_of? EditWindow
  @db.delete(edit_window.index)
  edit_window.destroy
end
do_save = lambda do
  edit_window = application.active_window
  return unless edit_window.instance_of? EditWindow
  if edit_window.index
    @db.change(edit_window.index, edit_window.record)
  else
    @db.append(edit_window.record)
  end
  edit_window.destroy
end
do_quit = lambda do
  application.quit
end
do_close = lambda do
  application.active_window.destroy
end

application.signal_connect "activate" do |app|
  action_accels = [
    ["app.append", ["<Control>n"]],
    ["app.cancel", ["<Control>k"]],
    ["app.delete", ["<Control>d"]],
    ["app.save", ["<Control>s"]],
    ["app.quit",   ["<Control>q"]],
    ["app.close",  ["<Control>w"]]
  ]
  action_accels.each do |_action_name, _action_accels|
    app.set_accels_for_action(_action_name, _action_accels)
  end

  actions = [
    ["append", do_append],
    ["cancel", do_cancel],
    ["delete", do_delete],
    ["save", do_save],
    ["quit", do_quit],
    ["close", do_close]
  ]
  actions.each do |action_name, handler|
    action = Gio::SimpleAction.new(action_name)
    action.signal_connect("activate") do |_action, _parameter|
      handler.call
    end
    app.add_action(action)
  end

  @topwindow = TopWindow.new(app)
  @db = DB.instance
  @db.init("word.csv", @topwindow.liststore)

  css_text = <<~EOS
  columnview {border: 1px solid lightgray; border-radius: 5px;}
  box#vbox {margin: 10px;} button#button_delete {color: red;}
  entry {margin-left: 10px;}
  textview {padding: 10px; border: 1px solid lightgray; border-radius: 10px;}
  textview {font-family: "Noto Sans CJK JP"; font-size: 12pt; font-style: normal;}
  EOS
  provider = Gtk::CssProvider.new #GtkCssProvider
  provider.load_from_data(css_text)
  Gtk::StyleContext.add_provider_for_display(@topwindow.window.display, provider, :user)

  @topwindow.window.show
end

# main routine

# To register WBRecord type
WBRecord.new

application.run

@db.close
