require 'minitest/autorun'
# sample class
class A
  def initialize
    @b = B.new
  end
  def show_b
    @b.show
  end
end
class B
  def show
    "class B のオブジェクトです\n"
  end
end
class TestStubAndMock < Minitest::Test
  def test_stub_and_mock
    @a = A.new
    assert_equal("class B のオブジェクトです\n", @a.show_b)
    @mock = Minitest::Mock.new
    B.stub(:new, @mock) do
      @a = A.new
    end
    @mock.expect(:show, "ぼくはモックだよ！\n")
    @mock.expect(:show, "わたしはモックよ！\n")
    assert_equal("ぼくはモックだよ！\n", @a.show_b)
    assert_equal("わたしはモックよ！\n", @a.show_b)
    @mock.verify
  end
end
