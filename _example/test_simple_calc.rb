require 'minitest/autorun'

class TestSimpleCalc < Minitest::Test
  def test_simple_calc
    assert_equal("100.0\n", `ruby simple_calc.rb 10*10`)
  end
end
