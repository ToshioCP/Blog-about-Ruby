require 'gtk4'

ui_string = <<EOS
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object id="window" class="GtkApplicationWindow">
    <property name="title">GtkColumnView</property>
    <property name="default-width">600</property>
    <property name="default-height">400</property>
    <child>
      <object class="GtkScrolledWindow">
        <child>
          <object class="GtkColumnView">
            <property name="model">
              <object class="GtkNoSelection">
                <property name="model">
                  <object id="liststore" class="GListStore"></object>
                </property>
              </object>
            </property>
            <child>
              <object class="GtkColumnViewColumn">
                <property name="title">英語</property>
                <property name="expand">false</property>
                <property name="fixed-width">250</property>
                <property name="factory">
                  <object class="GtkBuilderListItemFactory">
                    <property name="bytes"><![CDATA[
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <template class="GtkListItem">
    <property name="child">
      <object class="GtkLabel">
        <property name="hexpand">TRUE</property>
        <property name="xalign">0</property>
        <binding name="label">
          <lookup name="en" type = "EngJap">
            <lookup name="item">GtkListItem</lookup>
          </lookup>
        </binding>
      </object>
    </property>
  </template>
</interface>
                    ]]></property>
                  </object>
                </property>
              </object>
            </child>
            <child>
              <object class="GtkColumnViewColumn">
                <property name="title">日本語</property>
                <property name="expand">true</property>
                <property name="factory">
                  <object class="GtkBuilderListItemFactory">
                    <property name="bytes"><![CDATA[
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <template class="GtkListItem">
    <property name="child">
      <object class="GtkLabel">
        <property name="hexpand">TRUE</property>
        <property name="xalign">0</property>
        <binding name="label">
          <lookup name="jp" type = "EngJap">
            <lookup name="item">GtkListItem</lookup>
          </lookup>
        </binding>
      </object>
    </property>
  </template>
</interface>
                    ]]></property>
                  </object>
                </property>
              </object>
            </child>
          </object>
        </child>
      </object>
    </child>
  </object>
</interface>
EOS

class EngJap < GLib::Object
  type_register
  attr_accessor :en, :jp
  def initialize(en,jp)
    super()
    set_property("en", en)
    set_property("jp", jp)
  end
  install_property(GLib::Param::String.new("en", "en", "English", "", GLib::Param::READWRITE))
  install_property(GLib::Param::String.new("jp", "jp", "Japanese", "", GLib::Param::READWRITE))
  private :en, :en=, :jp, :jp=
end

application = Gtk::Application.new("com.github.toshiocp.subclass", :default_flags)

application.signal_connect "activate" do |app|
  builder = Gtk::Builder.new(string: ui_string)
  window = builder["window"]
  window.set_application(app)
  liststore = builder["liststore"]
  # サンプルデータ
  liststore.append(EngJap.new("hello", "こんにちは"))
  liststore.append(EngJap.new("good-bye", "さようなら"))
  window.present
end

application.run
