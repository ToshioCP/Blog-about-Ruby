print `pwd`
print %x{pwd}

p [1,2,3,4] #-> [1, 2, 3, 4]
pp [1,2,3,4] #-> [1, 2, 3, 4]

printf "%04d\n", 123
printf "%04d\n", 12
printf "%4d\n", 12

seq = (1..20).map{|i| [i, rand]}.sort{|a,b| a[1]<=>b[1]}.map{|a| a[0]}
print seq, "\n"

$stderr.print "エラーですよ\n"

abc = 10
if abc.class != Integer
  raise "abcが整数ではない!\n"
end

eval 'print "evalしたよ\n"'

if test(">", "_example/example2.rb", "_example/example1.rb")
  print "2の方が新しい\n"
else
  print "1の方が新しい\n"
end