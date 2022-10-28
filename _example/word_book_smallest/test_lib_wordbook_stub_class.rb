require 'minitest/autorun'
require_relative 'lib_wordbook.rb'

# dummy class
class Input
  def initialize
    @count = -1
  end
  def input
    @count += 1
    [['a', 'append', '付け足す'], ['d', 'append'], ['c', 'append', '付け加える'], ['p', 'app...'], ['q']][@count]
  end
end
class DB
  def initialize(*file)
  end
  def append(e,j)
    print "append(#{e}, #{j})\n"
  end
  def delete(e)
    print "delete(#{e})\n"
  end
  def change(e,j)
    print "change(#{e}, #{j})\n"
  end
  def list(e)
    print "list(#{e})\n"
  end
  def close
    print "close\n"
  end
end

class TestLibWordbook < Minitest::Test
  def setup
    @wordbook = WordBook.new
  end
  def test_run
    expected_output = "append(append, 付け足す)\ndelete(append)\nchange(append, 付け加える)\nlist(app...)\nclose\n"
    assert_output(expected_output) {@wordbook.run}
  end
end
