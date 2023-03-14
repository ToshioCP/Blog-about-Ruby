require 'benchmark'

@a = File.read("_example/pg28885.txt").scan(/[[:word:]]+/)

def install (w)
  @word_table.each do |a|
    if a[0] == w
      a[1] += 1
      return
    end
  end
  @word_table << [w, 1]
end

def wc1
  @word_table = []
  @a.each { |s| install(s) }
  @word_table.sort{|a,b| a[1] <=> b[1]}.reverse.take(10)
end

HSIZE = 5000

def wc_hash(s)
  s.hash % HSIZE
end

def install_hash (w)
  i = wc_hash(w)
  node = @h_table[i]
  if node == nil
    @h_table[i] = [nil, w, 1]
    return
  elsif node[1] == w
    node[2] += 1
    return
  else
    while node[0]
      if node[0][1] == w
        node[0][2] += 1
        return
      end
      node = node[0]
    end
    node[0] = [nil, w, 1]
  end
end

def get_words
  w = []
  @h_table.each do |node|
    while node
      w << [node[1], node[2]]
      node = node[0]
    end
  end
  w
end

def wc2
  @h_table = []
  @a.each { |s| install_hash(s) }
  get_words.sort{|a,b| a[1] <=> b[1]}.reverse.take(10)
end

def install_sym (w)
  s = w.to_sym
  if @symbol_hash.has_key?(s)
    @symbol_hash[s] += 1
  else
    @symbol_hash[s] = 1
  end
end

def wc3
  @symbol_hash = {}
  @a.each { |s| install_sym(s) }
  @symbol_hash.to_a.sort{|a,b| a[1] <=> b[1]}.reverse.take(10).map{|a| [a[0].to_s, a[1]]}
end

def w_test
  w1 = wc1; w2 = wc2; w3 = wc3
  if w1 != w2
    print "wc1 != wc2\n"
  end
  if w1 != w3
    print "wc1 != wc3\n"
  end
  if w2 != w3
    print "wc2 != wc2\n"
  end
end

def bm
  Benchmark.benchmark(Benchmark::CAPTION, 10, nil) do |rep|
    rep.report("wc") { wc1 }
    rep.report("wc_hash") { wc2 }
    rep.report("wc_sym_hash") { wc3 }
  end
end

def top10
  wc2.each do |a|
    print "#{a[0]}:  #{a[1]}\n"
  end
end

bm
