require 'minitest/autorun'

# stubの例
class Sample
  def a2b(file1, file2)
    src = File.read(file1)
    dst = src.gsub(/a/, 'b')
    File.write(file2, dst)
  end
end

class TestSample < Minitest::Test
  def test_a2b
    # @file = Minitest::Mock.new
    # @file.expect(:read, "abcd\n", [file])
    # @file.expect(:write, true, [file, s])
    w = proc {|x, y| @dst_content = y}
    File.stub(:read, "abcd\n") do
      File.stub(:write, w) do
        Sample.new.a2b("a.txt", "b.txt")
      end
    end
    assert_equal("bbcd\n", @dst_content)
  end
end

class TestStub < Minitest::Test
  def test_stub
    File.stub(:read, "abc\n", "p", "q") do
      File.read{|x,y| p x; p y} #=> "p" "q"
    end
  end
end

# mockの例 => 難しい
class Echo
  def initialize
    @in = Input.new
  end
  def echo
    while (s = @in.read) != 'quit'
      print s,"\n"
    end
  end
  def close
    @in.close
  end
end

class Input
end
class Echo
  attr_accessor :in
end

class TestEcho < Minitest::Test
  def test_echo
    echo = Echo.new
    echo.in = Minitest::Mock.new
    echo.in.expect(:read, "Hello world!")
    echo.in.expect(:read, "quit")
    assert_output("Hello world!\n"){echo.echo}
    echo.in.verify
  end
end

# mockの易しい例
class TestFoo < Minitest::Test
  def test_foo
    @mock = Minitest::Mock.new
    @mock.expect(:read, "Hello world!")
    assert_equal("Hello world!", @mock.read)
    @mock.verify
  end
end
