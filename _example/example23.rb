def to_number(s)
  s.to_i
end

# テストプログラム
def test_to_number
  a = to_number("0")
  print "0 にならずに #{a} が返された\n" unless a == 0
  a = to_number("-0.1")
  print "-0.1にならずに #{a} が返された\n" unless a == -0.1
  a = to_number("1.23e10")
  print "1.23e10にならずに #{a} が返された\n" unless a == 1.23e10
  a = to_number("abc")
  print "nilにならずに #{a} が返された\n" unless a == nil
  a = to_number(100)
  print "nilにならずに #{a} が返された\n" unless a == nil
end

test_to_number
#=> -0.1にならずに 0 が返された
#=> 1.23e10にならずに 1 が返された
#=> nilにならずに 0 が返された
#=> nilにならずに 100 が返された

# メソッドの再定義
def to_number(s)
  return nil unless s.is_a?(String)
  case s
  when /\A-?\d+\Z/
    s.to_i
  when /\A-?\d+\.\d+([Ee]\d+)?\Z/
    s.to_f
  else
    nil
  end    
end

print "\n"
test_to_number

require 'ripper'
p Ripper.lex("123 -1.2e5")
p Ripper.lex("123")

# メソッドの再々定義
def to_number(s)
  return nil unless s.is_a?(String)
  a = Ripper.lex(s)
  unless a.size == 1 || (a.size == 2 && a[0][1] == :on_op && a[0][2] == "-")
    return nil
  end
  case a[-1][1]
  when :on_int
    s.to_i
  when :on_float
    s.to_f
  else
    nil
  end    
end

print "\n"
test_to_number

# minitest
require 'minitest/autorun'
class TestToNumber < Minitest::Test
  def setup
  end
  def teardown
  end

  def test_to_number
    [["0",0],["12",12],["-5",-5],["12.34",12.34],["2.27421e5",2.27421e5],["-23.56",-23.56],["abc",nil], [123,nil]].each do |s,v|
      if v == nil
        assert_nil to_number(s)
      else
        assert_equal v, to_number(s)
      end
    end
  end
end

# 標準出力のテスト

@n = 0
def inc
  @n += 1
  p @n
end

inc
inc
inc

class TestInc < Minitest::Test
  def setup
    @n=0
  end
  def teardown
  end

  def test_inc
    assert_output("1\n") {inc}
    assert_output("2\n") {inc}
    assert_output("3\n") {inc}
  end
end
