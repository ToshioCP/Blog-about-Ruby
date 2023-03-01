def example1
  fiber = Fiber.new do
    "abc".each_char do |c|
      print "#{c}\n"
      Fiber.yield
    end
    nil
  end

  101.upto(103) do |j|
    fiber.resume
    print "#{j}\n"
  end
end

def example2
  a = [1,2,3].to_enum
  p a.next
  p a.next
  p a.next
end

def example3
  fiber = Fiber.new do
    [1,2,3].each do |i|
      Fiber.yield(i)
    end
  end

  p fiber.resume
  p fiber.resume
  p fiber.resume
end

def example4 filename
  fiber = Fiber.new do
    File.open(filename) do |file|
      while (s = file.gets)
        Fiber.yield(s)
      end
    end
    nil
  end

  nline = 0
  while fiber.resume
    nline +=1
  end
  print "#{nline}\n"
end

# main

example1
example2
example3
example4("_example/example39.rb")
