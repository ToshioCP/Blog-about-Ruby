a = ("a".."j").to_a.permutation.to_a.map{|ary| ary.join}.take(1000)
s = ""
a.each_with_index do |v, i|
  s << "#{v} = #{i+1}\n"
  s << "print #{v}\n"
end
File.write("_example/mini_sample2.txt", s)
