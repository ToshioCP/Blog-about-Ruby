require 'gtk4'

ls = Gio::ListStore.new(Gtk::StringObject.gtype)
s = Gtk::StringObject.new("abc")
ls.append(s)
p ls.get_item(0).string

class TupleString < GLib::Object
  type_register
  attr_accessor :s1, :s2
  def initialize(s1,s2)
    super()
    @s1, @s2 = s1, s2
  end
end

ls = Gio::ListStore.new(TupleString.gtype)
ts = TupleString.new("1", "2")
ls.append(ts)
p ls.get_item(0).s1, ls.get_item(0).s2
