require 'fileutils'
require 'benchmark'

files = Dir.children("_posts").map{|f| "_posts/#{f}"}
str = files.inject([]){|f1, f2| f1+File.readlines(f2)}
sym = str.map{|s| s.to_sym}
Benchmark.benchmark(Benchmark::CAPTION, 9, nil) do |rep|
  rep.report("str") { str.sort }
  rep.report("sym") { sym.sort }
end

print 100.hash, "\n"
print 100.hash, "\n"

a = [ 10, 100, 1000 ]
h = { "ten" => 10, 100 => 100, nil => 1000 }
print a[0], "\n"
print a[1], "\n"
print a[2], "\n"
print h["ten"], "\n"
print h[100], "\n"
print h[nil], "\n"
