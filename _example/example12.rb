class Sample
end

a = Sample.new
b = Sample.new
p a.class
p a.class.ancestors
p a.object_id
p b.object_id

# class Sample2
#   def inc
#     @c = 0 unless @c
#     @c += 1
#   end
#   def dec
#     @c = 0 unless @c
#     @c -= 1
#   end
# end

# class Sample2
#   def initialize
#     @c = 0
#   end
#   def inc
#     @c += 1
#   end
#   def dec
#     @c -= 1
#   end
# end

class Sample2
  def initialize(c=0)
    @c = c
  end
  def inc
    @c += 1
  end
  def dec
    @c -= 1
  end
end

# a = Sample2.new
a = Sample2.new(10)
p a.inc
p a.inc
p a.inc
p a.dec
p a.dec
p a.dec

class Node
  def initialize(d=nil)
    @d = d
    @nxt = nil
  end
  def data
    @d
  end
  def data=(d)
    @d=d
  end
  def nxt
    @nxt
  end
  def nxt=(n)
    @nxt = n
  end
  def insert(n)
    n.nxt = @nxt
    @nxt = n
  end
  def remove
    @nxt = @nxt.nxt
  end
end

start = Node.new
dog = Node.new("dog")
start.insert(dog)
cat = Node.new("cat")
dog.insert(cat)

n = start
while n.nxt
  print n.nxt.data, "\n"
  n = n.nxt
end

require 'readline'

Start = Node.new
@cur = 0
def get_node(i)
  n = Start
  i.times{n = n.nxt ? n.nxt : n}
  n
end
def all_data
  s = ""
  n = Start
  while n.nxt
    s << n.nxt.data
    n = n.nxt
  end
  s
end
while buf = Readline.readline("> ", false)
  c = buf[0]
  s = buf.slice(2,1000)
  case c
  when "q"
    break
  when "r"
    a = File.readlines(s)
    Start.nxt = nil
    n = Start
    a.each do |s|
      s = s + "\n" unless s[-1] == "\n"
      n.nxt = Node.new(s)
      n = n.nxt
    end
  when "s"
    File.write(s, all_data)
  when "l"
    n = get_node(@cur)
    i = 1
    while n.nxt
      print "#{@cur+i} #{n.nxt.data}"
      n = n.nxt
      i += 1
    end
  when "a"
    a = Node.new("#{s}\n")
    n = get_node(@cur)
    n.insert(a)
    @cur += 1
  when "r"
    n = get_node(@cur)
    n.remove
  when "m"
    @cur = s.to_i
  end
end
