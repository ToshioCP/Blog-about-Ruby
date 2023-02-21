require 'gtk4'
application = Gtk::Application.new("com.github.toshiocp.wordbook", :default_flags)
application.signal_connect "activate" do |app|
  Gtk::ApplicationWindow.new(app).present
end
application.run
