3.times do
  print "Hello world.\n"
end

print "\n"

10.times do
  print "Hello world.\n"
end

1.upto 5 do |i|
  print i
  print "\n"
end

10.downto(6) do |i|
  print i
  print "\n"
end

1.upto(5) {|i| print i; print "\n"}
