require_relative 'lib_calc.rb'

def get_answer a
  if a.instance_of?(Float) &&  a.to_i == a
    a.to_i.to_s
  else
    a.to_s
  end
end

Shoes.app title: "calc", width: 400, height: 80 do
  @calc = Calc.new
  flow do
    @edit_line = edit_line "", margin_left: 10
    @do_calc = button "計算", margin_left: 10
    @clear = button "クリア", margin_left: 3
    @close = button "終了", margin_left: 10
  end
  stack do
    @answer = para "", margin_left: 10
  end

  @do_calc.click do
    @answer.text = get_answer(@calc.run(@edit_line.text))
  end
  @clear.click {@edit_line.text = ""}
  @close.click {close}
end
