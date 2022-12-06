require 'gtk4'

ui_string = <<~EOS
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object id="window" class="GtkWindow">
    <child>
      <object class="GtkButton">
        <property name="label">Hello</property>
        <property name="action-name">app.hello</property>
        </object>
    </child>
  </object>
</interface>
EOS

def print_hello
  print "hello\n"
end

application = Gtk::Application.new("com.github.toshiocp.test", :default_flags)
application.signal_connect "activate" do |app|
  builder = Gtk::Builder.new(string: ui_string)
  window = builder["window"]
  window.set_application(app)

  app.set_accels_for_action("app.hello", ["<Control>h", "<Alt>h"])

  action = Gio::SimpleAction.new("hello")
  action.signal_connect("activate") do |_action, _parameter|
    print_hello
  end
  app.add_action(action)

  window.show
end
application.run
