class Vec
  def initialize(x=0, y=0)
    @x = x
    @y = y
  end
  def x
    @x
  end
  def y
    @y
  end
  def +(other)
    Vec.new(@x+other.x, @y+other.y)
  end
  def -(other)
    Vec.new(@x-other.x, @y-other.y)
  end
  def to_s
    "(#{@x}, #{@y})"
  end
end

a = Vec.new(1,2)
b = Vec.new(-2,4)
print "#{a} + #{b} = #{a+b}\n"
print "#{a} - #{b} = #{a-b}\n"

a.x = 100
