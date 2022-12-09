require 'gtk4'

class TopWindow < Gtk::ApplicationWindow
  type_register

  class << self
    def init
      ui_string = <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <template class="TopWindow" parent="GtkApplicationWindow">
          <child>
            <object class="GtkBox">
              <property name="orientation">GTK_ORIENTATION_VERTICAL</property>
              <property name="spacing">5</property>
              <child>
                <object id="search_entry" class="GtkSearchEntry">
                </object>
              </child>
              <child>
                <object id="print_button" class="GtkButton">
                  <property name="label">端末に出力</property>
                </object>
              </child>
            </object>
          </child>
        </template>
      </interface>
      EOS
      # set_template(:data => GLib::Bytes.new(ui_string))
      set_template(:data => ui_string)
      bind_template_child("search_entry")
      bind_template_child("print_button")
    end
  end

  def initialize(app)
    super(application: app)
    print_button.signal_connect("clicked") { print "#{search_entry.text}\n" }
    # signal_connect("close-request") { app.quit; true }
  end
end

application = Gtk::Application.new("com.github.toshiocp.subclass", :default_flags)
application.signal_connect "activate" do |app|
  TopWindow.new(app).show
end

application.run
