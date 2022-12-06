require 'gtk4'

class MainWindow
  def initialize(app)
    ui_string = <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <object id="window" class="GtkApplicationWindow">
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
        </object>
      </interface>
      EOS
    builder = Gtk::Builder.new(string: ui_string)
    @window = builder["window"]
    @window.set_application(app)
    @print_button = builder["print_button"]
    @search_entry = builder["search_entry"]
    @print_button.signal_connect("clicked") { do_print }
  end
  def window
    @window
  end

  private

  def do_print
    print "#{@search_entry.text}\n"
  end
end

application = Gtk::Application.new("com.github.toshiocp.subclass", :default_flags)
application.signal_connect "activate" do |app|
  MainWindow.new(app).window.show
end

application.run
