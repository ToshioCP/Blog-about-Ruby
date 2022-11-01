---
layout: posts
title: public、private、protected
description: メソッドの呼び出し制限
category: クラスとモジュール
date: 2022-10-5 12:24:06 +0900
---
今回はメソッドの呼び出し制限ついて説明します。
呼び出し制限にはpublic、private、protectedの3つがあります。

- [メソッドの公開と非公開](#メソッドの公開と非公開)
- [メソッドとレシーバ](#メソッドとレシーバ)
- [呼び出し制限](#呼び出し制限)
  - [publicメソッド](#publicメソッド)
  - [self](#self)
  - [privateメソッド](#privateメソッド)
  - [protectedメソッド](#protectedメソッド)
- [まとめ](#まとめ)

## メソッドの公開と非公開

英語のpublicとprivateは「公的な」「私的な」という形容詞ですが、同時に「公開の」「非公開の」という意味も持っています。
プログラム上では後者の意味でよく使われる単語です。
Rubyではprivateを「メソッドをクラス定義の外に非公開にする」ために良く用います。

```ruby
# プライベートメソッド（外から参照できないメソッド）の例
class Statistic
  def initialize array
    @array = array
  end
  def show
    print "合計は #{@array.sum}\n"
    print "平均は #{average(@array)}\n"
    print "標準偏差は #{stdev(@array)}\n"
  end
  private
  def average(array)
    (array.sum.to_f/array.size).round(1)
  end
  def stdev(array)
    mean = average(array)
    v = array.inject(0){|a,b| a+(b-mean)*(b-mean)}/array.size
    Math.sqrt(v).round(1)
  end
end

d = Statistic.new([5,6,7,8])
d.show
#=> 合計は 26
#=> 平均は 6.5
#=> 標準偏差は 1.1
p d.average([5,6,7,8]) #=> エラー、Privateメソッドを非関数形式で呼び出したため
p average([5,6,7,8]) #=> エラー、averageはトップレベルで未定義なため
```

この例ではStatisticクラスを定義しています。
このクラスは配列を引数にインスタンスを生成、初期化し、showメソッドで配列の統計量（合計、平均、標準偏差）を表示します。
クラスには3つのインスタンスメソッドshow、average、stdevが定義されていますが、クラス外部で使えるのはshowのみになっています。
最後の2行で、外部からaverageを呼び出していますが（片方はドットつき、他方はドットなし）いずれもエラーになります。
これはaverageがクラス定義の外部では呼び出せないことを示しています。
stdevも同様に外部からは呼び出せません。

これはクラス定義の中ほどにある`private`メソッドによって、以下の行で定義されたクラス定義内のメソッドが「private呼び出し制限」のメソッドになるためです。
「private呼び出し制限のメソッド」を短く「privateメソッド」といいますが、「メソッドの呼び出し制限を設定するためのprivateメソッド」と混乱するおそれがありますので、
文脈から注意深く判断するようにしてください。

showメソッドは`private`メソッドの前なのでpublicメソッドになります。
クラス定義におけるデフォルトはpublicです。

averageやstdevのようにクラス定義内では使うが、外からは使うことのないメソッドは、プログラム上で良く発生します。
そのようなメソッドを外部から呼び出すと問題が発生することが予想される場合は、privateメソッドにしておくべきです。
（上記の例ではそのような問題発生はありませんが、privateメソッドの例示のために設定しました）。

さて、privateの良くある使い方を説明しましたが、実はprivateの本当の意味は「非公開」ではなく、「関数形式でしか呼び出せない」なのです。
そこで、以下では呼び出し制限の定義とメソッドの振る舞いについて解説します。

## メソッドとレシーバ

まず、話の前提として「メソッドはレシーバとセットで呼び出される」ということを確認しておきたいと思います。
次の例を見てください

```ruby
class A
  def intro
    print "私はクラスAのインスタンスです\n"
  end
end
a = A.new
a.intro #=> 私はクラスAのインスタンスです
```

メソッドintroがクラスAのインスタンス・メソッドとして定義されました。
そのメソッドを呼び出すには

- クラスAのインスタンスを作成し、変数aに代入する
- 「インスタンス、ドット、メソッド名」の形、この例では`a.intro`の形でメソッドを呼び出す

このときのインスタンスを「メソッドのレシーバ」と呼びます。

もうひとつ大事なことは「レシーバのクラスでそのメソッドを定義済みである」ということがメソッド呼び出しの前提です。
上記の例ではクラスAでintroを定義しているのでa（の指すインスタンス）をレシーバとしてintroを呼び出せるわけです。

※　以下では「a（の指すインスタンス）」を単に「a」と書くことにします。

もし、定義されてなければエラーになります。

```ruby
class A
  # introを定義しない
end
a = A.new
a.intro #=> エラー（NoMethodError）
```

Aのサブクラス（直接の子でなくても孫から先でも良い）はインスタンス・メソッドを受け継ぐので、メソッド呼び出しが可能です。

```ruby
class A
  def intro
    print "私はクラスAのインスタンスです\n"
  end
end

class B < A
end

b = B.new
b.intro #=> 私はクラスAのインスタンスです
```

以上をまとめると

- メソッドはレシーバとセットで呼び出される
- レシーバのクラスでメソッドが定義されている、またはスーパークラスでメソッドが定義されていることが、メソッド呼び出しの前提である

ということになります。

## 呼び出し制限

呼び出し制限にはpublic、private、protectedの3つがあり、メソッドはこの3つのいずれかを持っています。

### publicメソッド

publicメソッドは制限なしに呼び出せます。
つまり、プログラムのどこでもそのメソッドを呼び出せます。
また、クラスでメソッドを定義するとき、そのメソッドの呼び出し制限のデフォルトはpublicです。
最初の例をもう一度見てみましょう。

```ruby
class A
  def intro
    print "私はクラスAのインスタンスです\n"
  end
end
a = A.new
a.intro #=> 私はクラスAのインスタンスです
```

メソッドintroの呼び出し制限はデフォルトのpublicです。
introはレシーバaとセットで、クラス定義の外で呼び出すことができます。
また、クラス定義の内部で呼び出すことも可能です。

```ruby
class C
  def calc(x)
    print "合計は#{sum(x)}、平均は#{average(x)}\n"
  end
  def sum(x)
    x.sum
  end
  def average(x)
    x.sum.to_f/x.size
  end
end
c = C.new
c.calc([1,2,3,4]) #=> 合計は10、平均は2.5
c2 = C.new
c2.calc([1,2,3,4]) #=> 合計は10、平均は2.5
```

クラスCの内部では3つのメソッドcalc、sum、averageが定義されています。
そして、メソッドcalcの中では、sumとaverageの2つのメソッドが呼ばれています。
ここで注意したいのは、これらのメソッドは「インスタンス、ドット」の部分が無いということです。
つまりレシーバが指定されていません。
このように、レシーバが省略されている呼び出し形式を「関数形式」といいます。
関数形式の呼び出しでは、レシーバはあるのですが、それが書かれていないだけなのです。
そのレシーバを「デフォルトのレシーバ」と、ここでは言うことにします。

では、デフォルトのレシーバは何かと言うと、それは（外部から）calcを呼び出したときのレシーバです。
`c=C.new`でクラスCのインスタンスが変数cに代入され、`c.calc([1,2,3,4])`でそのインスタンスをレシーバとしてcalcが呼ばれた時点でレシーバが確定します。
つまり、レシーバは変数cの指すインスタンスです。
同様に、最終行の`c2.calc([1,2,3,4])`ではc2の指すインスタンスがレシーバです。

calcメソッドを実行中にsumとaverageを関数形式で呼び出すとき、そのレシーバはcalcのレシーバを用います。

- c.calcを実行中＝＞関数形式の呼び出しは、c.sum、c.averageと同じ＝＞cがデフォルトのレシーバ
- c2.calcを実行中＝＞関数形式の呼び出しは、c2.sum、c2.averageと同じ＝＞c2がデフォルトのレシーバ

メソッド定義の中では「self」という疑似変数がデフォルトのレシーバを指します。
selfの指すインスタンスは、calcが呼ばれた時点で確定します。

プログラムの3行目は

```ruby
print "合計は#{self.sum(x)}、平均は#{self.average(x)}\n"
```

とレシーバselfを明示して書いても同じことになります。
ですが、特に何か意図するところがなければ、selfは省略するのが普通です。

ここでの説明をまとめると

- 関数形式のメソッド呼び出しではレシーバが省略される
- レシーバが省略されたときは、selfがレシーバになる
- selfが確定するのは、selfを含むメソッドが呼ばれたとき。
selfにはそのメソッドのレシーバが代入される

ということになります。

### self

今までのselfの説明はメソッド定義の中に限った話でした。
selfは他の場所では何を指しているのでしょうか？
一般にselfは次のようになっています。

- トップレベルでは、オブジェクトmain（Objectクラスのインスタンス）
- クラス定義またはモジュール定義の中ではクラス（またはモジュール）自身

となります。

※　mainについては[Rubyのドキュメント](https://docs.ruby-lang.org/ja/3.1/class/main.html)に記載があります。

注意が必要なのはメソッド定義の部分です。
「メソッドの定義」と「メソッドの呼び出し（または実行）」は別のことだと理解してください。
「メソッドを定義」しているときのselfと「メソッドを実行」しているときのselfは別物です。
メソッド定義には、メソッドを実行するときの振る舞いを書くのですから、selfも実行時の振る舞いが想定されなければなりません。
すなわち「selfには定義中のメソッドが実行されたときのレシーバが代入される」ということを想定してメソッド定義を書かなければなりません。

次の例で、selfが何を指すか確認してください。
表中央のselfはRubyがその行を実行中のselfです。
（「実行」には「クラス定義を実行」「メソッド定義を実行」などもあることに注意してください）。

|プログラム|self|メソッド実行中のself|
|:--------------|:-----|:----|
|class A|※||
|  def intro|A||
|    print "私はクラスAのインスタンスです\n"|A|introを呼び出したときのレシーバ|
|  end|A||
|end|※||
|a = A.new|main||
|a.intro #=> 私はクラスAのインスタンスです|main||

※のところはselfはmainだと思われるが未確認。

トップレベルとクラス、モジュール定義はselfが分かりやすいですけれども、メソッド定義の中のselfを考えるのは面倒な場合があります。
次の例を考えてみましょう。

```ruby
def average2(array)
  (array.sum.to_f/array.size).round(1)
end
def stdev2(array)
  mean = average2(array)
  v = array.inject(0){|a,b| a+(b-mean)*(b-mean)}/array.size
  Math.sqrt(v).round(1)
end

class Statistic2
  def initialize array
    @array = array
  end
  def show
    print "合計は #{@array.sum}\n"
    print "平均は #{average2(@array)}\n"
    print "標準偏差は #{stdev2(@array)}\n"
  end
end

d = Statistic2.new([2,4,3,9])
d.show
#=> 合計は 18
#=> 平均は 4.5
#=> 標準偏差は 2.7
```

- average2とstdev2は引数の配列のデータの平均、標準偏差を返す。これらはトップレベルで定義されている
- Statistic2クラスは、@arrayをインスタンス変数に持つ
- インスタンスを作る時に、newメソッドに配列を引数として渡し、それを@arrayに代入する
- showメソッドで合計、平均、標準偏差を表示する
- showメソッドの中でaverage2とstdev2メソッドが呼ばれている。

さて、このとき、selfはそれぞれの場所で何を表しているでしょうか？

- トップレベルでは、selfは「mainというオブジェクト」を指す。
- average2とstdev2の定義の内部のselfは、メソッド実行時にはそれが呼ばれたときのレシーバが代入される
- class〜endのshowメソッド定義のselfは、そのメソッド実行時にはそれが呼ばれたときのレシーバが代入される
- Statistic2クラスのインスタンスdが生成される。
- dをレシーバとしてshowメソッドが呼ばれる。
実行中のshowメソッドのselfはd
- showの中でaverage2とstdev2が関数形式で呼ばれる。
関数形式のときはselfをレシーバとして呼ぶので、ここではdがレシーバになる
- stdev2の中でaverage2が関数形式で呼ばれている。
関数形式なのでレシーバはself。
このときのselfはdである。
- dはStatistic2クラスのオブジェクトである。
Statistic2クラスではaverage2もstdev2も定義されていないが、dはaverage2とstdev2のレシーバになりうるのだろうか？

細かい分析と検討の結果、最後に？のついた疑問が出てきました。

この疑問に答えるには、トップクラスで定義されたメソッドの扱いを知る必要があります。
Rubyのドキュメントには次のように書かれています。

> トップレベルで定義したメソッドは Object の private インスタンスメソッドとして定義されます。

このことから、average2とstdev2はObjectクラスのメソッドです。

- average2とstdev2はObjectクラスのインスタンス・メソッド
- Statistic2クラスはスーパークラスの指定なく定義されているが、それでもObjectはStatistic2のスーパークラスになる。
（Objectはデフォルトですべての定義されるクラスのスーパークラス）
- スーパークラスのインスタンス・メソッドはサブクラスに継承される
- したがって、average2とstdev2はStatistic2クラスにも継承されている
- 変数dの指すオブジェクトをレシーバとしてaverage2とstdev2を呼ぶことが可能である

このように、selfがどのインスタンスを指していようと、そのインスタンスのクラスはObjectのサブクラスなので、トップレベルで定義されたメソッドを継承しています。
よって、selfはそのメソッドのレシーバになれるので、関数形式でそのメソッドを呼ぶことができるのです。

長い考察でしたが、簡潔にいうと

「トップレベルで定義したメソッドは、プログラムのどこでも関数形式で呼び出すことができる」

ということになります。

### privateメソッド

privateメソッドは関数形式（メソッド名だけでの呼び出し）でのみ呼び出せます（ただし「self.メソッド名」ならば呼び出すことが可能）。
ということは、privateメソッドは「selfをレシーバとしてのみ呼び出せる」ということです。

また、一般にメソッド呼び出しにおけるレシーバは次の条件を満たしていなければなりません。

- レシーバのクラスでそのメソッドが定義されている
- または、レシーバのクラスのスーパークラスがそのメソッドを定義している。
（逆に言えば、レシーバが「メソッドを定義したクラスのサブクラスのインスタンス」である）

この2つを組み合わせると、privateメソッドを呼び出すにはselfの指すオブジェクトのクラスが上記の2条件のいずれかを満たすことが必要です。
説明が複雑になるので、例をあげて説明します。

- privateメソッドprvがクラスCで定義されている
- publicメソッドpubがクラスCで定義されている
- Cのインスタンスをcとする

トップクラスではselfはmainを指していて、mailはObjectクラスのインスタンスで、Objectではprvメソッドが定義されていないので、prvを関数形式で（つまりselfであるmainをレシーバとして）呼ぶことはできません。
同様にトップクラスでpubも**関数形式**では呼べませんが、pubは「インスタンス、ドット、メソッド名」の形式でも呼び出せるので、`c.pub`として呼び出すことができます。

`c.pub`が実行されている間は常にselfとcは同じオブジェクトを指しています。
ですから、この実行の最中はprvを関数形式で呼び出すことが可能です。

それはどのようなときでしょうか？
それはpubの定義の中で直接または間接にprvを呼び出すときです。

以上の考察をまとめると

- privateメソッドは、そのクラス定義のメソッド定義（これはそのメソッド自身でも他のメソッドでも良い）の中で直接または間接に呼び出すことができる
- それ以外はprivateメソッドを呼び出すことができない。

ということになります。
「直接または間接」というのは後ほど説明します。

ただし、ひとつ注意が必要で、メソッドが定義されたクラスのサブクラスはメソッドを継承できるということから、サブクラス中のメソッド定義でもprivateメソッドを呼び出せます。

privateの本来の意味は「呼び出し形式が関数形式に限る」ということなのですが、その結果として「クラスとサブクラスの定義外では（通常は）呼び出せない」ということになります。
それがprivate（非公開）という名前になっている理由だと思われます。

実際問題、クラス定義の中だけで使われる関数は良くでてきます。
そのような関数にはprivateの設定をしましょう。

さて、クラス定義の中のメソッドはデフォルトでpublicでした。
privateにするためには`private`メソッドを使います。
このことは冒頭の例でも示しました。
privateメソッドを引数なしで呼び出すとその後のメソッドはすべてprivateメソッドになります。

また、`private`メソッドを引数つきで使うと、その引数のメソッドがprivateメソッドになります。
このときはprivateメソッドに先立って対象となるメソッドを定義しておかなければなりません。
引数のメソッド名にはシンボルまたは文字列を使いますが、シンボルを使う方が普通です。

```ruby
private :average
```

これにより、averageメソッドだけがprivateメソッドになります。
引数なしのprivateメソッドと異なり、引数付きのprivateメソッドでは以後のメソッドは引き続きデフォルトがpublicであるとして定義されます。

privateメソッドに対応するpublicメソッドとprotectedメソッドがあります。
これらはメソッド名を引数にとり、そのメソッドの呼び出し制限を設定します。
また、引数なしで実行されると、それ以後に定義されるメソッドすべての呼び出し制限を設定します。

最後に「直接または間接」を詳しく説明しましょう。
「直接呼び出す」の意味は明らかですから、「間接的に呼び出す」例を示します。

```ruby
class D
  def a
    print "privateメソッドaです\n"
  end
  def b
    c #トップレベルのメソッドcを呼び出す
  end
  private :a
end
def c
  a # privateメソッドaを呼び出す
end
d = D.new
d.b #=> privateメソッドaです
```

- このプログラムでは`private :a`によって、メソッドaの呼び出し制限がprivateになってる
- メソッドcはトップレベルのメソッドで、aを関数形式で呼び出している
- クラスDのインスタンスを生成し変数dに代入。`d.b`でpublicメソッドbを呼び出す
- メソッドbのselfはdである。bの中でトップレベルのメソッドcを呼ぶ
メソッドcはObjectのメソッドなのでサブクラスDで継承されている。
したがって、インスタンスdはメソッドcのレシーバになりうる。
よってメソッドcの呼び出しはエラーにならない
- cが呼ばれたときselfはdである。
dはaのレシーバになれるので、関数形式のaの呼び出しはエラーにならずに行われる
- aが呼び出されたので「privateメソッドaです」が表示される

この例ではprivateメソッドaがクラス定義の外で正常に呼び出されました。
それは、メソッドcがDのメソッドbから呼び出されたため、selfがdのままの状態でメソッドcが実行できたからです。
この場合privateメソッドaはDのメソッドbによって、cを通して間接に呼ばれています。
これが「間接的な呼び出し」の意味です。

bとは独立にcがaを呼び出すことはできません。

これは、privateメソッドがクラス外で呼び出せる例外です。
通常はprivateメソッドはクラス外から呼び出せないと考えても問題ありません。

### protectedメソッド

protectedメソッドはprivateメソッドに似た使い方ができますが、定義は違います。
protectedメソッドは「そのメソッドを持つオブジェクトが selfであるコンテキストでのみ」呼び出せます。

ここで難しいのが「コンテキスト」だと思います。
私も正確な定義は分かっていないのですが、実行時の「状態」をデータとしてまとめたものを一般にコンテキストというので、Rubyでも同様だと思います。
protectedの理解自体にはコンテキスト全体の理解までは必要ありません。
selfの状態だけを理解するだけで十分です。

さて、実行状態において、そのメソッドを持つオブジェクトがselfというのはどういうときでしょうか。
privateの最後の例では、メソッドがb=>c=>aと呼ばれる間ずっとselfとdは同じオブジェクトを指していました。
この状態が「そのメソッドを持つオブジェクトがself」です。
そのときにはprotectedメソッドは（関数形式でも関数形式でなくても）呼び出すことができます。

```ruby
class E
  def initialize(name)
    @name = name
  end
  def a
    print "protectedメソッドaです\n"
    print "レシーバは#{@name}です\n"
  end
  def b(e)
    e.a # selfはdになっているのでprotectedメソッドを使える
  end
  protected :a
end
d = E.new("d")
e = E.new("e")
d.b(e) #=> privateメソッドaです レシーバはeです
```

この例ではpublicメソッドbを呼び出した時に、selfはdと同じものを指しています。
「そのメソッドを持つオブジェクト(d)が selfであるコンテキスト」になっています。
そこで、protectedメソッドaが使えますが、ここではeをレシーバにして呼び出しています。
このように、関数形式ではない形でも呼び出せるのはprivateとの違いです。

## まとめ

- publicメソッドは制限なしに呼び出せる
- privateメソッドは関数形式（メソッド名のみでの呼び出し）でのみ呼び出せる（ただし「self.メソッド名」ならば呼び出すことができる）
- protectedメソッドは、そのメソッドを持つオブジェクトが selfであるコンテキストでのみ呼び出せる

この呼び出し制限から、privateメソッドとprotectedメソッドはクラス定義外では（一部例外を除いて）呼び出すことができません。
メソッドを「非公開」にするにはprivateでもprotectedでも同様の効果が期待できますが、privateを使っている例がほとんどです。
privateという名前が「非公開」をイメージしやすいからでしょうか。