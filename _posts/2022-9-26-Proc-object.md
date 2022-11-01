---
layout: posts
title: "Proc オブジェクト"
description: Procオブジェクトの定義と使い方
category: Procオブジェクト
date: 2022-9-26 22:48:18 +0900
---
今回はブロックを一般化したオブジェクトProcを説明します。

- [Procオブジェクトとは](#procオブジェクトとは)
- [Procオブジェクトの作り方](#procオブジェクトの作り方)
- [Procオブジェクトの使用例](#procオブジェクトの使用例)
- [Procオブジェクトをブロックとして使う](#procオブジェクトをブロックとして使う)
- [メソッドとブロックの違い](#メソッドとブロックの違い)
  - [ローカル変数の違い](#ローカル変数の違い)
  - [return、next、break](#returnnextbreak)

## Procオブジェクトとは

メソッドにはブロックをつけることができます。

```ruby
[1,2,3].each {|x| print x, "\n"}
# ブロックはdo〜endでも表せる
[1,2,3].each do |x|
  print x, "\n"
end
```

ブロックはオブジェクトにすることができます。
ブロックは動作を表すので、それがオブジェクトにできるというのは分かりにくいかもしれません。
しかし、考えてみれば「プログラム」はすべて文字列で表されており、文字列はオブジェクトなのですから、ブロックがオブジェクトになることは不思議でもなんでもありません。
ブロックのオブジェクトはProcクラスに属します。

## Procオブジェクトの作り方

ProcオブジェクトはProcクラスのオブジェクトですから`Proc.new`でインスタンス化できます。
そのインスタンスの内容となるブロックは、`Proc.new`の後ろにつけます。
そして、そのProcオブジェクトを実行するには`call`メソッドを使います。

```ruby
b = Proc.new {|x,y| x+y}
p b.call(10,20) #=> 30
```

Procオブジェクトは他のオブジェクト同様に

- 変数に代入することができる
- 式の中で使うことができる
- メソッドの引数にすることができる

という性質があります。

```ruby
b = Proc.new {|x,y| x+y}
p b.call(10,20) #=> 30
p 100+b.call(10,20) #=> 130

def abc(x, y, z)
  print x.call(y, z), "\n"
end

abc(b, 15, 25) #=> 40
```

この例でメソッドabcの引数にProcオブジェクトが代入されたのはすぐには理解が難しいかもしれません。
ですが、これは「慣れ」の問題だと思います。

`Proc.new`を含め、Procオブジェクトの作り方は3通りあります。

- `Proc.new`
- `proc`メソッド（Kernelモジュールのメソッド）
- `lambda`メソッド（Kernelモジュールのメソッド）。
lambdaメソッドの別形式であるアロー演算子（`->`）を用いることもできる

それぞれについてプログラム例を示します。

```ruby
b = Proc.new {|x,y| x+y}
p b.call(10,20) #=> 30
b = proc {|x,y| x*y}
p b.call(10,20) #=> 200
b = lambda {|x,y| x-y}
p b.call(10,20) #=> -10
# lambdaの新しい記法。->は「アロー演算子」と呼ばれる。
b = ->(x,y){(x+y)**2}
p b.call(10,20) #=> 900 = (10+20)^2
# [ ]を用いてもProcを呼び出せる
p b[10,20] #=> 900
# b.call(10,20)の糖衣構文
p b.(10,20) #=> 900
```

- どのやり方でも、後ろにブロックをつけ、そのブロックをオブジェクトにしたものが返される
- lamdaの別記法としてアロー演算子がある。
アロー演算子ではブロックのパラメータが波括弧の外に出て、かつ丸括弧で囲まれる。
この演算子は「ラムダ計算」の記法からきている。
`->`はギリシャ文字のラムダ（\\(\lambda\\)）の下半分が左にずれた形が由来だということがDavid Flanaganの「The Ruby Programing Language」に書いてあった。
この記法が好きなユーザもいるが、ラムダ計算を意識するのでなければ`lambda`メソッドを使うのが良いと思う（私の考え）
- Procオブジェクトを呼び出す別の方法として`[]`を使う方法もある。
また、糖衣構文で`.( )`という書き方もある

Proc.newとprocメソッドは同じオブジェクトを作成します。
lambdaメソッドで生成したオブジェクトはそれらと振る舞いが違います。
後の記事で説明しますが、詳細は[Rubyのドキュメント](https://docs.ruby-lang.org/ja/3.1/class/Proc.html)を参照してください。

今回はProc.newまたはprocメソッドで作成したProcオブジェクトについて説明します。

## Procオブジェクトの使用例

ブロックは、何らかのプログラムを実行することから、メソッドに似たものだと思われがちです。
しかし、メソッドとProcメソッドでの大きな違いのひとつは名前です。
メソッドが名前（メソッド名）を持ち、メソッド名で呼び出されるのに対し、Procオブジェクトには名前がありません。
変数に代入すれば、変数名で参照できますが、それはオブジェクトの名前ではありません。
しかし、名前でメソッドを呼ぶことに慣れている人は、Procオブジェクトにも名前をつけがちです（その名前は実は変数名ですが）。

```ruby
sum = proc{|array| array.sum}
p sum.call([1,2,3]) #=> 6
```

変数名sumが無くても同様のプログラムは作れます。

```ruby
p proc{|array| array.sum}.call([1,2,3]) #=> 6
```

このように名前が無いことはメソッドよりも自由度が高いということです。
そして、Procオブジェクトがオブジェクトである以上、他のオブジェクト同様に次のことが可能です。

- 変数、定数に代入できる
- 配列、ハッシュの要素になることができる
- メソッドの引数になれる

これ以外にもオブジェクトを置くことのできるところにはProcオブジェクトを置くことができます。
Procオブジェクトをハッシュの要素にする例を示しましょう。
これは配列の数値データを統計データと見て合計や平均などを表示するプログラムです。

```ruby
sum = proc{|a| a.sum}
mean = proc{|a| (a.sum.to_f/a.size).round(1)}
var = proc{|a| (mean.call(a.map{|x| (x-mean.call(a))**2}).round(2))}
stdev = proc{|a| (var.call(a)**0.5).round(2)}
max = proc{|a| a.max}
min = proc{|a| a.min}
sort = proc{|a| a.sort}
reverse = proc{|a| a.reverse}
@stat_functions = {sum: sum, mean: mean, var: var, stdev: stdev, max: max, min: min, sort: sort, reverse: reverse}

def report(items, d)
  items.each do |item|
    print "#{item}: #{@stat_functions[item].call(d)}\n"
  end
end

items = [:sum, :mean, :stdev, :max, :min, :sort]
data = [5,3,10,2,6]
report(items, data)
```

はじめに合計(sum)から逆順並べ替え（reverse）までのProcオブジェクトを変数に代入しています。
実は直接次の@stat\_functionsに代入するハッシュのリテラルに書き込みたかったのですが、分散と標準偏差でProcオブジェクトを使うため断念し、このような形にしました。
なお、meanは平均のことで、統計学ではaverageでなくmeanを使います。
すべてのProcオブジェクトのパラメータは、整数または実数を要素とする配列を想定しています。
すべてのProcオブジェクトをひとつのハッシュに組み込んでいます。

メソッドreportは項目とデータ（配列）からそれを表示するものです。
項目は、@stat\_functionsのキーとなっているシンボルのうち、表示したいものを集めた配列です。

最後の3行で項目とデータを指定し、そのレポートを表示しています。
実行すると次のように表示されます。

```
sum: 26
mean: 5.2
stdev: 2.79
max: 10
min: 2
sort: [2, 3, 5, 6, 10]
```

項目を変えると、表示も変わってきます。

このようにProcオブジェクトは、ハッシュに埋め込んだり、配列に埋め込んだりすることができます。
また名前がないので、名前の衝突を心配する必要もありません。
RubyのプログラマはあまりProcオブジェクトを使っていないように見受けられますが、もっと活用できるし、活用すべきだと思います。

## Procオブジェクトをブロックとして使う

Procオブジェクトはブロックをオブジェクト化したものだから、ブロックとしても使えます。
そのときには、メソッドの最後の引数に入れ、かつ`&`記号をつけます。

ブロックを直接書くのとProcオブジェクトで渡すのと両方示しますので比べてください。

```ruby
show = proc{|x| print x, "\n"}

# ブロックを直接書く
[1,2,3].each{|x| print x, "\n"}

# Procオブジェクトを使う
[1,2,3].each(&show)
```

両方とも同じもの（1、2、3）が表示されます。
比べてみるとeachメソッドの後ろにブロックが付くか、Procオブジェクトが付くかの違いだけだとわかります。
実は、ブロックはeachメソッドの最後の引数になっているのです。
直接ブロックを書くのとProcオブジェクトを渡すのは同じではありませんが、ほぼ同等に思って構いません。

この&を使う方法はメソッドをオブジェクト化したMethodオブジェクトにも使うことができます。

```ruby
# Methodオブジェクトをブロックに使う
[1,2,3].each(&method(:p))
```

`method`はObjectクラスのメソッドで、引数の名前（メソッド名はシンボルを使います）のメソッドをMethodオブジェクトに変換します。
このプログラムは

```ruby
[1,2,3].each{|x| p x}
```

と同様の働きをします。

このとき`&method(:p)`の「methodメソッド」を省略して`&:p'とするとエラーになります。
この2つは似ていますが、

- Methodオブジェクトに&をつけるとブロックに渡される引数がそのままメソッドの引数になる
- Symbolオブジェクト（そのシンボルはメソッド名）に&をつけるとブロックに渡される第1引数をレシーバとしてメソッドが呼ばれる

例えば

```ruby
# シンボルに&をつけると第1引数がレシーバになる
p [1,2,3].map(&:to_s)
```

これを実行すると

```
["1", "2", "3"]
```

と表示されます。
つまり、mapの引数は順に1、2、3なので、それをレシーバとして`1.to_s`から`3.to_s`が実行されて配列が返されます。

`[1,2,3].each(&:p)`とすると、`1.p`を計算しようとしてエラーが起こります。

本題に戻ります。
以上をまとめると、Procオブジェクトは&をつけてメソッドの最後の引数にすると、その部分がブロックとしてメソッドで実行される、ということです。

## メソッドとブロックの違い

### ローカル変数の違い

メソッド定義の外側で定義されたローカル変数は。メソッド定義内では参照できません。

```ruby
a = 10

def abc
  p a #=>未定義のaを参照し、エラーが起こる
end
```

これに対してブロックの外側で定義されたローカル変数はブロック内からも参照できます。

```ruby
a = 10

[1,2,3].each do |x|
  p a+x
end
```

このとき、ブロック内でもa=10となるので、

```
11
12
13
```

と表示されます。
これはProcオブジェクトの定義でも同じで

```ruby
a = 10
b = proc {|x| a + x}
p b.call(20) #=> 30
```

変数aはprocメソッド後のProcオブジェクト呼び出しでも参照できます。

ブロック内で定義されたローカル変数はブロックの終了とともに参照できなくなります。

```ruby
[1,2,3].each{|x| c = 10+x}
p c #=> cはブロックの外では参照できず、未定義の変数参照としてエラーになる
```

Procオブジェクトは（procメソッドの前に定義された）ローカル変数を保持し続けます。

注意：procメソッド内で定義されたローカル変数のスコープは（procメソッドの）ブロック内のみですので、procメソッドの終了とともに消えてしまいます。

```ruby
a = 10
b = proc{ a }
p b.call #=> 10
a = 20
p b.call #=> 20
```

このようになるのは、変数bの参照するProcオブジェクトが変数`a`を持ち続けるからです。
もし、このプログラムがメソッド定義の中で行われたとしましょう。
そのメソッドが実行された時にProcオブジェクトが生成されます。
もしこのProcオブジェクトがメソッドから抜け出た後も残っていたら、メソッドのローカル変数`a`は外部からは使えませんが、
Procオブジェクトの`a`と`a`の指すオブジェクトはずっと残ることになります。
そうでなければローカル変数はメソッド実行が終了した時点で消え、オブジェクトもガベージコレクションで消えるでしょう。

このようにProcオブジェクトはブロックとしての動作だけでなくローカル変数とオブジェクトを保持することに注意してください。
これもメソッドとの大きな違いです。
このようなオブジェクトを保持するProcオブジェクト（一般に手続き）はクロージャーと呼ばれます。

### return、next、break

- returnはメソッドを終了して呼び出し元に返る
- nextは最も内側のループの現在の回を終了して次の回に移る。
ブロックの場合も同様。
yieldを抜け出すと考えても良い
- breakは最も内側のループを抜け出す。
ブロックの場合も同様で、ブロックの外に抜け出す

注意しなければならないのは、これらの使い方です。

- ブロック内でreturnを使うとブロックの外側のメソッド（メソッド定義されているメソッド、実行時のメソッドではない）から抜け出すことになる
- ブロック内でbreakを使うとブロックが付いているメソッドの外側に出る（そのメソッドが一番内側のループだから）
- callで呼ばれたProcオブジェクトから抜け出して元に戻るにはnextを使う

要するに、メソッド定義でメソッドを終了して呼び出し元に戻る命令はreturnで、Procオブジェクトではnext。

メソッドとProcオブジェクトは似ているが、このあたりの違いを押さえておかないと悲劇が待っているかも・・・