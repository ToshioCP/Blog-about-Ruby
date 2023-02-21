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

  builder = Gtk::Builder.new(file: "calc.ui")
  window = builder["window"]
  entry = builder["entry"]
  entry_buffer = entry.buffer
  button_calc = builder["button_calc"]
  button_clear = builder["button_clear"]
  button_quit = builder["button_quit"]
  label = builder["label"]

  window.set_application(app)
  if @gtk_version == 3
    window.default_height = 80
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
    window.present
  else
    window.show_all
  end
end

application.run
