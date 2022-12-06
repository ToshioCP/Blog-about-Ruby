require "gtk4"
require_relative "db.rb"

# This file contains three objects.
# Class EditWindow
# GtkApplicationWindow
# GtkApplication
# The global variable $editwindow is shared by main and TopWindow class object.

# EditWindow object is a wrapper for GtkWindow.
class EditWindow
  attr_accessor :index
  def initialize
    builder = Gtk::Builder.new(string: Edit_window_ui)
    @window = builder["window"]
    @entry_en = builder["entry_en"]
    @entry_jp = builder["entry_jp"]
    @textview = builder["textview"]
  end
  def set_application(app)
    @window.set_application(app)
  end
  def record=(record)
    @entry_en.text = record[0]
    @entry_jp.text = record[1]
    @textview.buffer.text = record[2]
  end
  def record
    [@entry_en.text, @entry_jp.text, @textview.buffer.text]
  end
  def show
    @window.show
  end
  def close
    @window.destroy
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
      $editwindow = EditWindow.new
      $editwindow.set_application(@window.application)
      $editwindow.record = DB.instance.record(index)
      $editwindow.index = index
      $editwindow.show
    end

    search_entry.signal_connect("activate") do |entry|
      begin
        regexp = Regexp.compile(entry.text)
      rescue RegexpError
        regexp = //
      end
      custom_filter.set_filter_func { |wbrecord| regexp =~ wbrecord.to_a[0] }
      custom_filter.changed(:different)
    end
  end

  def window
    @window
  end
  def show
    @window.show
  end
  def set_application(app)
    @window.set_application(app)
  end
  def liststore
    @liststore
  end
  def close
    @window.destroy
  end
end

# GtkApplication

application = Gtk::Application.new("com.github.toshiocp.wordbook", :default_flags)

# action handlers
do_append = lambda do
  $editwindow = EditWindow.new
  $editwindow.set_application(application)
  $editwindow.index = nil
  $editwindow.show
end
do_cancel = lambda do
  if $editwindow
    $editwindow.close
    $editwindow = nil
  end
end
do_delete = lambda do
  if $editwindow
    @db.delete($editwindow.index)
    $editwindow.close
    $editwindow = nil
  end
end
do_save = lambda do
  if $editwindow
    if $editwindow.index
      @db.change($editwindow.index, $editwindow.record)
    else
      @db.append($editwindow.record)
    end
    $editwindow.close
    $editwindow = nil
  end
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

  @topwindow.show
end

# main routine

# To register WBRecord type
WBRecord.new
# UI string
Edit_window_ui = File.read("edit_window.ui")

application.run

@db.close
