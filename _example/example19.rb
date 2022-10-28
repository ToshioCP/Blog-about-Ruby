x = nil
case x
when 1 then p "x is 1."
when 2 then p "x is 2."
else p "x is not 1 or 2."
end

if 1 === x then p "x is 1."
elsif 2 === x then p "x is 2."
else p "x is not 1 or 2."
end

class A
end

p Kernel == Kernel
p Kernel === A
p Kernel == A
p A.kind_of?(Kernel)

p proc{|x| x*x} == proc{|x| x*x}
p proc{|x| x*x == 0} === 1
p proc{|x| x*x == 0} === 0


# 引数を2乗して返すメソッド
def square x
  case x
  when Numeric
    x*x
  else # impossible to calculate, return nil
    return nil
  end
end

p square("abc") #=> nil （文字列は数字でない）
p square(2) #=> 4
p square(1.2) #=> 1.44
p square(Complex("1+2i")) #=> (-3+4i) 複素数も計算できる
p square(Rational("2/3")) #=> (4/9) 分数（有理数）も計算できる

element_type = lambda do |a|
  return unless a.instance_of? Array # lambdaではreturnで手続きオブジェクトを抜けることができる
  b = a.map{|e| e.class}.uniq #要素のクラスの配列を作り、重複を除く
  case b.size
  when 0 then nil # 空の配列だった
  when 1 then b[0] #クラス名を返す
  else        "mixed" #2つ以上の種類のオブジェクトが要素に含まれる 
  end
end

p element_type.call([1,2,3]) #=> Integer
p element_type.call(["a","b","c"]) #=> String
p element_type.call([[1,2],[3,4],[5,6]]) #=> Array
p element_type.call([1,"2",3.0]) #=> mixed

@is_array_of_Numeric = lambda do |a|
  return false unless a.instance_of? Array # lambdaではreturnで手続きオブジェクトを抜けることができる
  b = a.map{|e| e.kind_of?(Numeric)}.uniq #要素のクラスの配列を作り、重複を除く
  case b.size
  when 0 then false # 空の配列だった
  when 1 then b[0] # true(Numericクラス)かfalse（そうでない）を返す
  else        false # Numericとそうでない要素が混じっていた
  end
end

def square_elements a
  case a
  when @is_array_of_Numeric
    a.map{|x| x*x}
  else
    a
  end
end

p square_elements([1,2,3]) #=> [1, 4, 9]
p square_elements([1.0, 2,Complex("2+3i"),Rational("5/7")]) #=> [1.0, 4, (-5+12i), (25/49)]
p square_elements(["a","b","c"]) #=> ["a", "b", "c"]
p square_elements([[1,2],[3,4],[5,6]]) #=>[[1, 2], [3, 4], [5, 6]]
p square_elements([[1,"2",3.0]]) #=> [[1, "2", 3.0]]


def lex(s)
  result = []
  while true
    break if s == ""
    case s[0]
    when /[[:alpha:]]/
      m = /\A([[:alpha:]]+)(.*)\Z/m.match(s)
      if m[1] == "print"
        result << [:print, nil]
      else
        result << [:id, m[1]]
      end
      s = m[2]
    when /[[:digit:]]/
      m = /\A([[:digit:]]+)(.*)\Z/m.match(s)
      result << [:num, m[1].to_i]
      s = m[2]
    when /[+\-*\/()=]/
      result << [s[0].to_sym, nil]
      s = s[1..-1]
    when /\s/
      s = s[1..-1] 
    else
      raise "Unexpected character."
    end
  end
  result
end

p lex("abc = (2+3)*6\nprint abc\n")
p lex("abc = 100 % 30\n")

