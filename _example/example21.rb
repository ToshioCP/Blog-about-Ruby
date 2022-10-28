class A
end

a = A.new
b = A.new

def a.intro
  print "私はaです\n"
end

a.intro #=> 私はaです
# b.intro #=> エラー（undefined method error）

c = A
p c #=> A
p c.class #=> Class

def A.intro
  print "私はクラスAです\n"
end

A.intro #=> 私はクラスAです

class << A
  undef intro
end

class A
  def A.intro
    print "私はクラスAです\n"
  end
end

A.intro #=> 私はクラスAです

class << A
  undef intro
end

class A
  def self.intro
    print "私はクラスAです\n"
  end
end

A.intro #=> 私はクラスAです

class B < A
end
B.intro

module C
end

def C.intro
  print "私はモジュールCです\n"
end

C.intro #=> 私はモジュールCです

class A
end
a = A.new
b = A.new
class << a
  def intro
    print "私はaです\n"
  end
end
a.intro #=> 私はaです
# b.intro #=> エラー（NoMethodError)

p "新しい定義"
class << A
  undef intro
end
# A.intro #=> エラー（NoMethodError)
# B.intro #=> エラー（NoMethodError)
class A
  class << self
    def intro
      print "私はクラスAです\n"
    end
  end
end
A.intro #=> 私はクラスAです
B.intro #=> 私はクラスAです

p Math.sin(Math::PI/3) #=> 0.8660254037844386
include Math
p sin(PI/3) #=> 0.8660254037844386

module X
  def intro
    print "私はモジュールXのモジュール関数です\n"
  end
  module_function :intro
end
X.intro #=> 私はモジュールXのモジュール関数です
include X
intro #=> 私はモジュールXのモジュール関数です

module Y
  def self.intro
    print "私はモジュールYです\n"
  end
end
Y.intro

module ABC
  class A
    def intro
      print "モジュールABCのAです\n"
    end
  end
end
module EFG
  class A
    def intro
      print "モジュールEFGのAです\n"
    end
  end
end

a = ABC::A.new
b = EFG::A.new
a.intro #=> モジュールABCのAです
b.intro #=> モジュールEFGのAです
