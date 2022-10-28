# プライベートメソッド（外から参照できないメソッド）の例
class Statistic
  def initialize array
    @array = array
  end
  def show
    print "合計は #{@array.sum}\n"
    print "平均は #{average(@array)}\n"
    print "標準偏差は #{stdev(@array)}\n"
  end
  private
  def average(array)
    (array.sum.to_f/array.size).round(1)
  end
  def stdev(array)
    mean = average(array)
    v = array.inject(0){|a,b| a+(b-mean)*(b-mean)}/array.size
    Math.sqrt(v).round(1)
  end
end

d = Statistic.new([5,6,7,8])
d.show
#=> 合計は 26
#=> 平均は 6.5
#=> 標準偏差は 1.1
# p d.average([5,6,7,8]) #=> エラー、Privateメソッドを非関数形式で呼び出したため
# p average([5,6,7,8]) #=> エラー、averageはトップレベルで未定義なため

class A
  # introを定義しない
end
a = A.new
# a.intro #=> エラー（NoMethodError）

class A
  def intro
    print "私はクラスAのインスタンスです\n"
  end
end
a = A.new
a.intro #=> 私はクラスAのインスタンスです

class B < A
end
b = B.new
b.intro #=> 私はクラスAのインスタンスです

class C
  def calc(x)
    print "合計は#{sum(x)}、平均は#{average(x)}\n"
  end
  def sum(x)
    x.sum
  end
  def average(x)
    x.sum.to_f/x.size
  end
end
c = C.new
c.calc([1,2,3,4]) #=> 合計は10、平均は2.5
c2 = C.new
c2.calc([1,2,3,4]) #=> 合計は10、平均は2.5

def average2(array)
  (array.sum.to_f/array.size).round(1)
end
def stdev2(array)
  mean = average2(array)
  v = array.inject(0){|a,b| a+(b-mean)*(b-mean)}/array.size
  Math.sqrt(v).round(1)
end

class Statistic2
  def initialize array
    @array = array
  end
  def show
    print "合計は #{@array.sum}\n"
    print "平均は #{average2(@array)}\n"
    print "標準偏差は #{stdev2(@array)}\n"
  end
end

d = Statistic2.new([2,4,3,9])
d.show
#=> 合計は 18
#=> 平均は 4.5
#=> 標準偏差は 2.7

# privateメソッドのテスト
class Psample
  # private :a #=> エラー、メソッドが定義されていない（NameError）
  def a
    print "私はaです\n"
    self.b
  end
  def b
    print "私はbです\n"
  end
  private "b" # メソッド名は文字列OK。シンボルでもOK
end
psample = Psample.new
psample.a
# psample.b #=> エラー、プライベートメソッド呼び出し（NoMethodError）


class D
  def a
    print "privateメソッドaです\n"
  end
  def b
    c #トップレベルのメソッドcを呼び出す
  end
  private :a
end
def c
  a # privateメソッドaを呼び出す
end
d = D.new
d.b #=> privateメソッドaです

class E
  def initialize(name)
    @name = name
  end
  def a
    print "protectedメソッドaです\n"
    print "レシーバは#{@name}です\n"
  end
  def b(e)
    e.a # selfはdになっているのでprotectedメソッドを使える
  end
  protected :a
end
d = E.new("d")
e = E.new("e")
d.b(e) #=> privateメソッドaです レシーバはeです
