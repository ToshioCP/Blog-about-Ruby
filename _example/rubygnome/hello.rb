@gtk_version = (ARGV.size == 1 && ARGV[0] == "3") ? 3 : 4

require "gtk#{@gtk_version}"
print "Require GTK #{@gtk_version}\n"

application = Gtk::Application.new("com.github.toshiocp.hello", :default_flags)

application.signal_connect "activate" do |app|
  window = Gtk::ApplicationWindow.new(app)
  window.set_default_size 400,300
  window.title = "Hello"

  label = Gtk::Label.new("Hello World")
  if @gtk_version == 4
    window.child = label
    window.show
  else
    window.add(label)
    window.show_all
  end
end

application.run
