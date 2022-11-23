@gtk_version = (ARGV.size == 1 && ARGV[0] == "3") ? 3 : 4

require "gtk#{@gtk_version}"
print "Require GTK #{@gtk_version}\n"

require_relative "lib_calc.rb"

def get_answer a
  if a.instance_of?(Float) &&  a.to_i == a
    a.to_i.to_s
  else
    a.to_s
  end
end

application = Gtk::Application.new("com.github.toshiocp.calc", :default_flags)

application.signal_connect "activate" do |app|
  calc = Calc.new
  window = Gtk::ApplicationWindow.new(app)
  window.default_width = 400
  if @gtk_version == 4
    window.default_height = 120
  else
    window.default_height = 80
  end
  window.title = "Calc"

  vbox = Gtk::Box.new(:vertical, 5)
  window.child = vbox

  hbox = Gtk::Box.new(:horizontal, 5)
  label = Gtk::Label.new("")
  if @gtk_version == 4
    vbox.append(hbox)
    vbox.append(label)
  else
    vbox.pack_start(hbox)
    vbox.pack_start(label)
  end
    
  entry = Gtk::Entry.new
  entry_buffer = entry.buffer
  button_calc = Gtk::Button.new(label: "計算")
  button_clear = Gtk::Button.new(label: "クリア")
  button_quit = Gtk::Button.new(label: "終了")
  if @gtk_version == 4
    hbox.append(entry)
    hbox.append(button_calc)
    hbox.append(button_clear)
    hbox.append(button_quit)
  else
    hbox.pack_start(entry)
    hbox.pack_start(button_calc)
    hbox.pack_start(button_clear)
    hbox.pack_start(button_quit)
  end
    
  button_calc.signal_connect "clicked" do
    label.text = get_answer(calc.run(entry_buffer.text))
  end
  button_clear.signal_connect "clicked" do
    entry_buffer.text = ""
  end
  button_quit.signal_connect "clicked" do
    if @gtk_version == 4
      window.destroy
    else
      window.close
    end
  end

  if @gtk_version == 4
    window.show
  else
    window.show_all
  end
end

application.run
