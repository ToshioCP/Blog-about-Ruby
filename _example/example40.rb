require "fileutils"
include FileUtils

# 以下のプログラムを実行すると、a-zと100-200の出力が混じり合う。
# ただし、場合によっては混ざらずに先にa-zで後から100-200が出たり、逆に100-200が先でa-zが後ということもありうる。
# ここでは3つのスレッドが並行して動いていて、t1、t2、メインの3つである。
# joinメソッドによって、メインはt1とt2のスレッドの終了を待つようになる。
# これをしておかないと、メインスレッドが先に終了するときに、すべてのスレッドも終了してしまう。
# それによって、それぞれのスレッドの作業が完了しないことも十分にあり得る。

def ax100200
  t1 = Thread.new {("a".."z").each {|c| print "#{c}\n"}}
  t2 = Thread.new {(100..200).each {|x| print "#{x}\n"}}
  t1.join
  t2.join
end

ax100200

# シーケンシャルは「順を追って」、コンカレントは「並行して」という意味である。
# シーケンシャルに複数タスクを実行するのは、ひとつずつ順に行うことで、
# コンカレントに複数タスクを実行するのは、全部（または一部）を同時並行に行うことである。
# コンカレントの効果が表れるのは処理に時間がかかるI/O関係の処理を伴う場合である。
# そこで、入力をシーケンシャルで行う場合とコンカレントで行う場合を比較してみた。

# 以下のプログラムを2回実行すると、予想外にシーケンシャルな方が速かった。しかも2回目はその差がさらに大きくなっている。
# おそらく、最初の実行でキャッシュが生成され、読込時間が大きく短縮されたためではないだろうか。
# 読込よりもスレッド生成の時間の方が実行時間に影響していると思われる。
# 尚、実験時点でファイル数は37個であった。したがって、スレッドも37個作られたことになる。
# スレッドをあまりに多く生成しすぎると実行時間の低下をもたらすということが言えそうだ。

# $ ruby _example/example40.rb
# 0.011881702
# 0.034613109
# $ ruby _example/example40.rb
# 0.000459287
# 0.034651356

def s_read(files)
  files.each {|f| File.read(f)}
end

def c_read(files)
  threads = []
  files.each do |file|
    threads << Thread.new(file) {|f| File.read(f)}
  end
  threads.each {|t| t.join}
end

def s_or_c_input
  files = Dir.glob("_example/*.rb")

  t1 = Time.now
  s_read(files)
  t2 = Time.now
  p t2 - t1

  t1 = Time.now
  c_read(files)
  t2 = Time.now
  p t2 - t1
end

# s_or_c_input

# 以下のプログラムは書き込みの速さを比較するものである。
# この場合もシーケンシャルなプログラムがコンカレントよりも速かった。
# スレッド作成の時間が速さに影響したようだ。
# 両者とも2回目が1回目と比べ、大幅に時間短縮されている。これはキャッシュの効果かと思われる。

# $ ruby _example/example40.rb
# 0.035471335
# 0.054183784
# $ ruby _example/example40.rb
# 0.004797201
# 0.038642262

def s_write(files_and_data)
  odir = "_example/_test_s"
  Dir.mkdir(odir)
  files_and_data.each do |file, data|
    b = File.basename(file)
    File.write(odir+"/"+b, data)
  end
  remove_entry_secure(odir)
end

def c_write(files_and_data)
  odir = "_example/_test_c"
  Dir.mkdir(odir)
  threads = []
  files_and_data.each do |file, data|
    threads << Thread.new(file) do |f|
      b = File.basename(f)
      File.write(odir+"/"+b, File.read(f))
    end
  end
  threads.each {|t| t.join} 
  remove_entry_secure(odir)
end

def s_or_c_write
  files = Dir.glob("_example/example*.rb")
  files_and_data = files.map{|f| [f, File.read(f)]}

  t1 = Time.now
  s_write(files_and_data)
  t2 = Time.now
  p t2 - t1

  t1 = Time.now
  c_write(files_and_data)
  t2 = Time.now
  p t2 - t1
end

# s_or_c_write

# 時間がかかる処理を待たずに次の入力をできるよう、スレッドを使ってみた。
# Readline.readlineのプロンプトが瞬くような感じの動作がある。
# スレッドの影響がこのオブジェクトに対してあるようだ。
# 下記の例においてもプロンプトが2個出てしまっているものがある。
# これもその「瞬き」効果である。

# 処理を待たずに次の入力はできるが、プログラムの終了はすべてのメソッドの終了後になるので、時間がかかる。

# あたりまえだが、コンカレントの場合、早く終わったほうが先にファイルに書き込む。
# だから、５，１と入力すると１のときの値が先にファイルに書かれる。
# この点はシーケンシャルと違うので注意が必要だ。

# $ ruby _example/example40.rb
# > 5
# > 
# > 1
# $ cat tempfile
# 5000000050000000
# 125000000250000000

require "readline"

def rl
  threads = []
  # If the input is EOF (ctrl-d), Readline.readline returns nil.
  while buf = Readline.readline("> ", false)
    i = buf.to_i
    if 1 <= i && i <= 9
      threads << Thread.new(i) do |n|
        x = (1..(n*100000000)).inject {|a,b| a+b}
        File.open("tempfile","a") {|file| file.print("#{x}\n")}
      end
    end
  end
  threads.each {|t| t.join}
end

# rl