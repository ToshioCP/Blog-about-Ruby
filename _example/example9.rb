print 1.0.class, "\n"
print 1.0, "\n"
print -2.3, "\n"
print 3.4e5, "\n"
print 3.4e-3, "\n"

print 0.2+0.4, "\n"
if 0.2+0.4 == 0.6
  print "equal\n"
else
  print "not equal\n"
end

print 1000000000+0.000000001, "\n"

print 1 / 2, "\n"
print 1.0 / 2, "\n"

# This is a comment.
s = File.read("_example/example9.rb") #This is also a comment.
s = s.gsub(/#.*$/, "")
File.write("_example/file2.rb", s)
