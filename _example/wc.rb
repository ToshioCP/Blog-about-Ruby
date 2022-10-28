require 'benchmark'

@a = File.read("_example/pg28885.txt").split(/[^A-Za-z]+/)

def install_a (w)
  @word_table_a.each do |a|
    if a[0] == w
      a[1] += 1
      return
    end
  end
  @word_table_a << [w, 1]
end

def wc1
  @word_table_a = []
  @a.each { |s| install_a(s) }
  @word_table_a.sort{|a,b| a[1] <=> b[1]}.reverse.take(10)
end

def install_s (w)
  s = w.to_sym
  if @word_table_s.has_key?(s)
    @word_table_s[s] += 1
  else
    @word_table_s[s] = 1
  end
end

def wc2
  @word_table_s = {}
  @a.each { |s| install_s(s) }
  @word_table_s.to_a.sort{|a,b| a[1] <=> b[1]}.reverse.take(10).map{|a| [a[0].to_s, a[1]]}
end

def w_test
  if wc1 != wc2
    print "wc1 != wc2\n"
  end
end

def bm
  Benchmark.benchmark(Benchmark::CAPTION, 14, nil) do |rep|
    rep.report("wc with array") { wc1 }
    rep.report("wc with hash") { wc2 }
  end
end

def top10
  wc2.each do |a|
    print "#{a[0]}:  #{a[1]}\n"
  end
end

# w_test
# top10
bm
