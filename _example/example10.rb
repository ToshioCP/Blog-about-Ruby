print [1,2,3].map {|i| i+1} , "\n" #=>[2,3,4]

d = "_example"
paths = Dir.children(d).map {|file| d + "/" + file}
paths.each {|p| print "#{p}\n"}

b = []
[1,2,3].each {|i| b << i+1 }
print b, "\n" #=> [2, 3, 4]

print [1,3,5].inject {|i, j| i+j}, "\n" #=> 9

print [1,2,3].inject([]) {|i, j| i << j+1}, "\n" #=>[2,3,4]

print [1,3,2].sort, "\n" #=>[1,2,3]
print [1,3,2].sort{|a,b| -(a<=>b)}, "\n" #=>[3,2,1]

a = ["9", "5", "13", "20", "12", "4"]
print a.sort, "\n"
print a.sort{|a,b| a.to_i<=>b.to_i}, "\n"

print 1..2, "\n"
print({one: 1, two: 2}, "\n")
print ({one: 1, two: 2}), "\n"

print Time.now, "\n" #=> 2022-09-19 16:10:15 +0900
