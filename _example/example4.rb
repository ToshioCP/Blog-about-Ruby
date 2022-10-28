def example
  print "Hello world.\n"
end

3.times do
  example
end

def sum a, b
  a + b
end

print (sum 5, 10)
print "\n"

print sum 10, 20
print "\n"

def double x
  2*x
end

print double (2) + 3
print "\n"

print double(2) + 3
print "\n"

def even_or_odd(n)
  if n.even?
    print "偶数です\n"
  else
    print "奇数です\n"
  end
end

even_or_odd(3)
even_or_odd(6)

def fact(n)
  if n<1
    nil
  elsif n==1
    1
  else
    n*fact(n-1)
  end
end

print fact(5)
print "\n" 

print fact(-1)
print "\n" 

print nil
print "\n" 
