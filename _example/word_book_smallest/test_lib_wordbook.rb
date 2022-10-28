require 'minitest/autorun'
require_relative 'lib_wordbook.rb'

# dummy class
class Input
end
class DB
  def initialize(*file)
  end
end

class TestLibWordbook < Minitest::Test
  def test_run
    @mock_input = Minitest::Mock.new
    @mock_db = Minitest::Mock.new
    Input.stub(:new, @mock_input) do
      DB.stub(:new, @mock_db) do
        @wordbook = WordBook.new
      end
    end

    args = []
    args << [['a', 'append', '付け足す'], :append, nil, ['append', '付け足す']]
    args << [['d', 'append'], :delete, nil, ['append']]
    args << [['c', 'append', '付け加える'], :change, nil, ['append', '付け加える']]
    args << [['p', 'app...'], :list, [['append', '付け加える']], ['app...']]

    args.each do |a|
      @mock_input.expect(:input, a[0])
      @mock_db.expect(a[1], a[2], a[3])
      @mock_input.expect(:input, ['q'])
      @mock_db.expect(:close, nil)
      if a[0][0] == 'p'
        assert_output("append - 付け加える\n") {@wordbook.run}
      else
        @wordbook.run
      end
      @mock_input.verify
      @mock_db.verify
    end
  end
end
