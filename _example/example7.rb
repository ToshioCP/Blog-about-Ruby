a = "abc" "def" "ghi"
b = "abc
def"
c = "pqr" "stu"
"vwx"
print a, "\n"
print b, "\n"
print c, "\n"

a = "abcd\
efg"
b = "abcd" \
"efg"
print a, "\n"
print b, "\n"

number = 100
print "数字は#{number}\n"

a = 'abc\ndef'
b = 'abc\\ndef'
c = '\abc
def'
d = 'abc\
def'
print a, "\n"
print b, "\n"
print c, "\n"
print d, "\n"

a = <<EOS
　春はあけぼの。やうやう白くなりゆく山ぎは、すこしあかりて、紫だちたる雲のほそくたなびきたる。
　夏は夜。月のころはさらなり。やみもなほ、蛍の多く飛びちがひたる。また、ただ一つ二つなど、ほのかにうち光りて行くもをかし。雨など降るもをかし。
　秋は夕暮れ。夕日のさして山の端いと近うなりたるに、烏の寝どころへ行くとて、三つ四つ、二つ三つなど、飛びいそぐさへあはれなり。まいて雁などのつらねたるが、いと小さく見ゆるはいとをかし。日入りはてて、風の音、虫の音など、はたいふべきにあらず。
　冬はつとめて。雪の降りたるはいふべきにもあらず、霜のいと白きも、またさらでもいと寒きに、火など急ぎおこして、炭もて渡るもいとつきづきし。昼になりて、ぬるくゆるびもていけば、火桶の火も白き灰がちになりてわろし。
EOS

print a

a = "Hello world. Hello world.\n"
if /Hello/ =~ a
  print "マッチした\n"
else
  print "マッチしなかった\n"
end

print (/Hello/ =~ a), "\n"

a = "## 配列のリテラル"
if /^\#{1,6} +(.+)$/ =~ a
  print $1, "\n"
end

m = /^\#{1,6} +(.+)$/.match("## 配列のリテラル")
print m[1], "\n"

m = /^\#{1,6} +(.+)$/.match("## 配列のリテラル")
print m[1], "\n"
print m.to_a[1], "\n"
m = /^\#{1,6} +(.+)$/.match("配列のリテラル")
print m.class, "\n"
print m.to_a[1], "\n"
# print m[1]

a = "abcdefg"
b = a.sub(/def/, "DEF")
print "a = ", a, "\n"
print "b = ", b, "\n"

a = "abcdefg"
b = a.sub!(/def/, "DEF")
print "a = ", a, "\n"
print "b = ", b, "\n"

a = "abcdefg"
b = a.sub(/ddd/, "DEF")
print "a = ", a.object_id, "\n"
print "b = ", b.object_id, "\n"

a = "abcdefg"
b = a.sub!(/ddd/, "DEF")
print "a = ", a.class, "\n"
print "b = ", b.class, "\n"

print "abcdef\n".sub(/ddd/,"DEF").sub(/ab/,"AB")
# print "abcdef\n".sub!(/ddd/,"DEF").sub!(/ab/,"AB")

print "abcdefg\n".sub(/d(..)g/,'\1')

a = '\1'
print "abcdefg\n".sub(/d(..)g/){ a+$1 }

print "a,b,c".split(",")
print "\n"

c = <<EOS
2,3,5,7,11
13,17,19,23,29
31,37,41,43,47
53,59,61,67,71
73,79,83,89,97
EOS
c.split(/[,\n]/).each do |i|
  print i, "\n"
end

print "\n"

c = <<EOS
2,3,5,7,11
13,17,19,23,29
31,37,41,43,47
53,59,61,67,71
73,79,83,89,97
EOS
c.scan(/\d+/).each do |i|
  print i, "\n"
end
