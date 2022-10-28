a = lambda{|x| print x, "\n"}
a.call("Hello")
a["Hi"]
a = proc{|x| print x, "\n"}
a.call("Hello")
a["Hi"]

a = proc{|x,y| p x; p y}
a.call(1)
a.call(1,2,3)

def b
  @a = proc{return}
  @a.call
  p 10
end

b
# @a.call #=> LocalJumpError

a = lambda{|x| x+2}
b = lambda{|x| x*x}
c = a << b
p c.call(5)
c = b << a
p c.call(5)

a = lambda{|x| x.size}
b = lambda{|x| x.split(/\W/)}
e = "I declare before you all that my whole life, whether it be long or short, "\
"shall be devoted to your service and to the service of our great imperial family to which we all belong."
p (a << b).call(e)

a = lambda{|x,y| x+y}
b = a.curry #=> lambda{|x| lambda{|y| x+y}}
c = b.call(2) #=> lambda{|y| 2+y}
p c.call(3) #=> 5

# curry化を確かめる
# b = lambda{|x| lambda{|y| x+y}}
# c = b.call(2)
# p c.call(3)

# アロー演算子での表現
a = ->(x,y){x+y}
b = a.curry #=> ->(x){->(y){x+y}}
c = b[2] #=> ->(y){2+y}
p c[3] #=> 5


# 配列のmapで要素を2乗するのをProcオブジェクトで表しcurry化
a = ->(x,y){y.map(&x)} # yが配列でxがProcオブジェクト
b = ->(x){x*x}
p a.curry[b][[1,2,3,4]]

square = a.curry[b] # cは配列要素を2乗するProcオブジェクト
p square[[5,6,7,8,9,10]]

add2 = a.curry[->(x){x+2}]
p add2[[5,6,7,8,9,10]] #=> [7, 8, 9, 10, 11, 12
p (add2 << square)[[5,6,7,8,9,10]] #=> [27, 38, 51, 66, 83, 102]
p (square << add2)[[5,6,7,8,9,10]] #=> [49, 64, 81, 100, 121, 144]
