require 'benchmark'

Benchmark.benchmark(Benchmark::CAPTION, 9, nil) do |rep|
  rep.report("mini") { system("ruby _example/mini.rb _example/mini_sample2.txt > /dev/null") }
  rep.report("mini2") { system("ruby _example/mini2.rb _example/mini_sample2.txt > /dev/null") }
end
