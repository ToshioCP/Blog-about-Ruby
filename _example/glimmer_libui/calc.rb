require 'glimmer-dsl-libui'
require_relative 'lib_calc.rb'

include Glimmer

def get_answer a
  if a.instance_of?(Float) &&  a.to_i == a
    a.to_i.to_s
  else
    a.to_s
  end
end

window('calc', 400, 80) { |w|
  calc = Calc.new
  vertical_box {
    horizontal_box {
      @e = entry
      horizontal_box {
        button("計算") {
          on_clicked do
            @answer.text = "  "+get_answer(calc.run(@e.text))
          end
        }
        button("クリア") {
          on_clicked do
            @e.text = ""
          end
        }
        button("終了") {
          on_clicked do
            w.destroy
            LibUI.quit
            0
          end
        }
      }
    }    
    @answer = label("")
  }
}.show
