print 10
print "\n"

print 1+2
print "\n"
print 10-3
print "\n"
print 2*3
print "\n"
print 10/2
print "\n"
print 20/3
print "\n"

print (2-4)*(3+5)
print "\n"

print 123456789123456789*123456789123456789
print "\n"

print 1_000_000_000_000
print "\n"

print 20.abs
print "\n"
print -30.abs
print "\n"

print 12.gcd(18)
print "\n"
print 20.gcd 30
print "\n"

# コンマ区切りの整数出力の３方法

def comma1 n
  n.digits(1000).reverse.inject{|a,b| a.to_s+','+sprintf("%03d",b)}.to_s
end
def comma2 n
  n.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
end

print comma1 1234567890
print "\n"
print comma2 1234567890
print "\n"

require "yukichi"

print Yukichi.new(1234567890).jpy_comma()
print "\n"
