a = [1, 2, 3]
print a[1]
print "\n"

a[1] = 5
print a
print "\n"

a[6] = 10
print a
print "\n"

abc = %w!a b c!
print abc
print "\n"

abc = %w|! !! !!!|
print abc
print "\n"

ab = %w(睦月 如月 弥生)
cd = %w[卯月 皐月 水無月]
ef = %w{文月 葉月 長月}
gh = %w<神無月 霜月 師走>
print ab
print "\n"
print cd
print "\n"
print ef
print "\n"
print gh
print "\n"

a = (1 .. 10).to_a
print a
print "\n"

# a = (0..29).map {(rand(0)*100).round}
a = [43, 14, 44, 9, 35, 23, 28, 99, 49, 99, 32, 31, 61, 60, 77, 91, 69, 90, 21, 36, 55, 77, 80, 37, 42, 37, 8, 91, 92, 94]
print "人数 = #{a.size}\n"
print "平均 = #{(a.sum.to_f/a.size).round(1)}\n"
print "最高 = #{a.max}\n"
print "最低 = #{a.min}\n"

[1,2,3,4,5].each do |i|
  print i
  print "\n"
end

a = ["青", "黃", "赤"]
a.each_index do |i|
  print i
  print " => "
  print a[i]
  print "\n"
end

["青", "黃", "赤"].each_with_index do |x, i|
  print i
  print " => "
  print x
  print "\n"
end

a = "a"
b = "b"
[a, b].clear
print a, b, "\n"

a = "abc"
b = "def"
c = [a, b]
print c, "\n"
c[0] = "ABC"
print a, "\n"
print c, "\n"

ARGV.each do |x|
  print x, "\n"
end
