require 'minitest/autorun'
require_relative 'lib_calc.rb'

class TestCalc < Minitest::Test
  def setup
    @calc = Calc.new
  end
  def teardown
  end

  def test_lex
    "sin|cos|tan|asin|acos|atan|exp|log".split("|").each do |func|
      assert_equal [[func.to_sym,nil],[:'(',nil],[:id,"x"],[:')',nil]], @calc.lex("#{func}(x)")
    end
    assert_equal [[:'(',nil],[:'-',nil],[:num,2.0],[:'+',nil],[:id,"abc"],[:')',nil],[:'*',nil],[:'(',nil],[:num,1.2],[:'+',nil],[:id,"def"],[:')',nil]], @calc.lex("(-2+abc)*(1.2+def)")
    assert_equal [[:id,"a"],[:'=',nil],[:num,100.0]], @calc.lex("a = 100")
    assert_equal [[:PI,nil],[:E,nil]], @calc.lex("PI E")
    assert_equal [[:num,2],[:'**',nil],[:num,3]], @calc.lex("2**3")
  end

  # test parse with lex
  def test_parse
    assert_equal "100", @calc.run("10*10")
    assert_equal "-6", @calc.run("-2*3")
    assert_equal "15", @calc.run("(2+3)*(5-2)")
    assert_equal "1.56", @calc.run("1.2*1.3")
    assert_equal "10", @calc.run("x=10")
    assert_equal "3.141592653589793", @calc.run("PI")
    assert_equal "2.718281828459045", @calc.run("E")
    assert_equal "1", @calc.run("sin(PI/2)")
    assert_equal "1", @calc.run("log(E)")
    assert_equal "1.4142135623730951", @calc.run("sqrt(2)")
    assert_equal "100", (@calc.run("20");@calc.run("v*5"))
    assert_equal "8", @calc.run("2**3")
    assert_equal "syntax error.", @calc.run("10+")
    assert_equal "syntax error.", @calc.run("")
  end
end
