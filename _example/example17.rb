[1,2,3].each {|x| print x, "\n"}
# ブロックはdo〜endでも表せる
[1,2,3].each do |x|
  print x, "\n"
end

b = Proc.new {|x,y| x+y}
p b.call(10,20) #=> 30
p 100+b.call(10,20) #=> 130

def abc(x, y, z)
  print x.call(y, z), "\n"
end

abc(b, 15, 25) #=> 40

b = proc {|x,y| x*y}
p b.call(10,20) #=> 200
b = lambda {|x,y| x-y}
p b.call(10,20) #=> -10
# lambdaの新しい記法。->は「アロー演算子」と呼ばれる。
b = ->(x,y){(x+y)**2}
p b.call(10,20) #=> 900 = (10+20)^2
# [ ]を用いてもProcを呼び出せる
p b[10,20] #=> 900
# b.call(10,20)の糖衣構文
p b.(10,20) #=> 900

sum = proc{|array| array.sum}
p sum.call([1,2,3]) #=> 6

p proc{|array| array.sum}.call([1,2,3]) #=> 6

sum = proc{|a| a.sum}
mean = proc{|a| (a.sum.to_f/a.size).round(1)}
var = proc{|a| (mean.call(a.map{|x| (x-mean.call(a))**2}).round(2))}
stdev = proc{|a| (var.call(a)**0.5).round(2)}
max = proc{|a| a.max}
min = proc{|a| a.min}
sort = proc{|a| a.sort}
reverse = proc{|a| a.reverse}
@stat_functions = {sum: sum, mean: mean, var: var, stdev: stdev, max: max, min: min, sort: sort, reverse: reverse}

def report(items, d)
  items.each do |item|
    print "#{item}: #{@stat_functions[item].call(d)}\n"
  end
end

items = [:sum, :mean, :stdev, :max, :min, :sort]
data = [5,3,10,2,6]
report(items, data)


show = proc{|x| print x, "\n"}

# ブロックを直接書く
[1,2,3].each{|x| print x, "\n"}

# Procオブジェクトを使う
[1,2,3].each(&show)

# メソッドをブロックに使う
[1,2,3].each(&method(:p))

# シンボルに&をつけると第1引数がレシーバになる
p [1,2,3].map(&:to_s)


a = 10
[1,2,3].each do |x|
  p a+x
end
b = proc {|x| a+x}
p b.call(20) #=> 30

# [1,2,3].each{|x| c = 10+x}
# p c #=> エラー

a = 10
b = proc{ a}
p b.call #=> 10
a = 20
p b.call #=> 20

p [1,2,3].each{|x| break 1000 }

b = proc{ c = 100; [a,c]}
p b.call #=> [20,100]
c = 200 # b内のcとは別物なので、bには影響を与えない
p b.call #=> [20,100]
a = 30 #b内のaと同一オブジェクトを指している
p b.call #=> [30,100]

def person(s)
  name = s.dup
  return proc{ print "name: #{name}\n"}
end

# suzukiとtanakaはProcオブジェクトである。
# そのProcオブジェクトはメソッドpersonのスコープを持っているのでnameを保持している。
# Procオブジェクトがなければ、nameにはアクセスできなくなり、nameの参照するオブジェクトはどこからも参照されずGCされるが、
# Procオブジェクトのために引き続き存在し続ける。
# このような機能をクロージャという。
# クロージャは定義時点の環境と手続きをセットで持っているオブジェクトである。
s = "鈴木"
suzuki = person(s)
s.replace "田中"
tanaka = person(s)
suzuki.call #=> name: 鈴木 personメソッドの中でnameは複製されているので、sのreplaceは影響しない。もしdupがなければ「田中」になる。
tanaka.call #=> name: 田中
# クロージャはこの点でメソッドに似ている。
# メソッドはレシーバ（インスタンス）を持っているからである。
# 上記のpersonと同様のことはクラス定義＋インスタンス生成でもできる。
class Person
  def initialize s
    @name = s.dup
  end
  def display
    print "name: #{@name}\n"
  end
end
s = "鈴木"
suzuki = Person.new(s)
s.replace "田中"
tanaka = Person.new(s)
suzuki.display #=> name: 鈴木
tanaka.display #=> name: 田中
