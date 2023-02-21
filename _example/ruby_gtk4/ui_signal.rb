require 'gtk4'

ui_string = <<~EOS
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object id="window" class="GtkWindow">
    <child>
      <object class="GtkButton">
        <property name="label">Button</property>
        <signal name="clicked" handler="button_cb"></signal>
      </object>
    </child>
  </object>
</interface>
EOS

def button_cb(button)
  print "clicked\n"
end

application = Gtk::Application.new("com.github.toshiocp.test", :default_flags)
application.signal_connect "activate" do |app|
  builder = Gtk::Builder.new(string: ui_string)
  window = builder["window"]
  window.set_application(app)
  window.present
end
application.run
