require 'minitest/autorun'
require_relative 'input.rb'

class TestInput < Minitest::Test
  def test_input
    @in = Input.new
    Readline.stub(:readline, "a append 付け足す") { assert_equal(['a', 'append', '付け足す'], @in.input) }
    Readline.stub(:readline, "d append") { assert_equal(['d', 'append'], @in.input) }
    Readline.stub(:readline, "c append 付け足す") { assert_equal(['c', 'append', '付け足す'], @in.input) }
    Readline.stub(:readline, "p a..end") { assert_equal(['p', 'a..end'], @in.input) }
    Readline.stub(:readline, "q") { assert_equal(['q'], @in.input) }
    m = Minitest::Mock.new
    m.expect(:call, "abcd", ["wb > ", false])
    m.expect(:call, "q", ["wb > ", false])
    Readline.stub(:readline, m) {assert_output(nil, "(a|c) 英単語 日本語訳\nd 英単語\np 正規表現\nq\n"){ @result = @in.input }}
    assert_equal(['q'], @result)
  end
end
