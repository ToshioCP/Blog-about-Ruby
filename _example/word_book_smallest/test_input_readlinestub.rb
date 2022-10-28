require 'minitest/autorun'
require 'readline'
require 'stringio'
require_relative 'input.rb'

module Readline
  def self.readline(pronpt="> ", history=false)
    unless @stringio
      @stringio = StringIO.new("a append 付け足す\nd append\nc append 付け足す\np a..end\nq\nabcd\nq\n")
    end
    @stringio.readline.chomp
  end
end

class TestInput < Minitest::Test
  def test_input
    @in = Input.new
    assert_equal(['a', 'append', '付け足す'], @in.input)
    assert_equal(['d', 'append'], @in.input)
    assert_equal(['c', 'append', '付け足す'], @in.input)
    assert_equal(['p', 'a..end'], @in.input)
    assert_equal(['q'], @in.input)
    assert_output(nil, "(a|c) 英単語 日本語訳\nd 英単語\np 正規表現\nq\n"){ @result = @in.input }
    assert_equal(['q'], @result)
  end
end
