require 'minitest/mock'

# delegator
m = Minitest::Mock.new("Hello world")
# m is a mock
p m #=> <Minitest::Mock:0x00007f809dedab50 @delegator="Hello world", @expected_calls={}, @actual_calls={}>
# Because m (mock) uses the delegator's method, m.display is the same as "Hello.world".display
m.display #=> Hello world
print "\n"
print m+"\n" #=> Hello world\n
# Because m has its own to_s method, m.to_s is NOT "Hello world".to_s
print m, "\n" #=> <Minitest::Mock:0x00007f8130db2c08>

m.expect(:size, 1000)
print m.size, "\n" #=> 1000, the size method is defined by m.expect.
print m.length, "\n" #=> 11, which is the real length of "Hello world"
p m #=> <Minitest::Mock:0x00007f264bd96e30 @delegator="Hello world", 
    # @expected_calls={:size=>[{:retval=>1000, :args=>[], :kwargs=>{}}]},
    # @actual_calls={:size=>[{:retval=>1000, :args=>[], :kwargs=>{}}]}>
p m.verify #=> true
# m.size #=> Error: No more expects available for :size

# arguments
m.expect(:concat, "Hello, folks.", [String, Integer])
print m.concat("Foo", 100), "\n" #=> Hello world, folks.
# m.expect(:concat, "Hello world, there.", [Integer])
# print m.concat("abc"), "\n" #=> Error :concat called with unexpected arguments
# m.expect(:concat, "Hello, there.", [String, String])
# print m.concat("abc"), "\n" #=> Error :concat expects 2 arguments

m.expect(:concat, "Hello, folks.", [String], a:10,b:20,c:30)
print m.concat("abc", a:10, b:20, c:30), "\n" #=> Hello, folks.
m.expect(:concat, "Hello, folks.", ["efg"], a:10,b:20,c:30)
print m.concat("efg", a:10, b:20, c:30), "\n" #=> Hello, folks.

m.expect(:concat,"Hello, there.") {|x,y| x.is_a?(String) && y.is_a?(Integer)}
print m.concat("a", 1), "\n" #=> Hello, there.
m.expect(:concat,"Hello, there.") {|x,y,&z| x.is_a?(String) && y.is_a?(Integer) && z.call(10)==100}
print m.concat("a", 1){|x| x*x}, "\n" #=> Hello, there.
p m.verify #=> true
