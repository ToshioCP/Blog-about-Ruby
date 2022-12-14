---
layout: posts
title: 演算子の再定義
description: 演算子の再定義
category: クラスとモジュール
date: 2022-9-21 10:30:00 +0900
---
Rubyの演算子とその再定義について書きます。

## Rubyの演算子

[Rubyのドキュメント](https://docs.ruby-lang.org/ja/3.0/doc/spec=2foperator.html)によると、次のような演算子があります。
表の「意味」は正確ではなく「およそ」「良く用いられる場合」についての説明です。

|優先度|演算子|意味|
|:--------|:--------|:-----|
|高い|`::`|「クラス::定数」など|
||`[]`|配列参照など|
||`+`(単項演算子) `!` `~`|正符号、論理否定、ビット反転|
||`**`|累乗|
||`-`(単項演算子)|負符号|
||`*` `/` `%`|積、商、剰余|
||`+` `-`|和、差|
||`<<` `>>`|ビットシフト、追加|
||`&`|ビット積|
||`|` `^`|ビット和、排他的論理和|
||`>` `>=` `<` `<=`|大小比較|
||`<=>` `==` `===` `!=` `=~` `!~`|比較、等、不等|
||`&&`|論理積「かつ」|
||`||`|論理和「または」|
||`..` `...`|範囲|
||`?:`|条件演算子、三項演算子|
||`=` (`+=`, `-=`など)|代入（自己代入）|
||`not`|論理否定|
|低い|`and` `or`|論理積、和|

これらの演算子のうち一部は糖衣構文によってメソッドに置き換えられます。
ということはそれらの演算子はオブジェクトごとに定義されているので、様々な意味付けがありえます。
表の中の「意味」はよく使われるオブジェクトに対する「意味」です。

## 糖衣構文

ここで、糖衣構文（シンタックス・シュガー）について少し詳しく見てみます。

プログラムの中で

```ruby
a == b
```

が出てきたとします。
aとbは変数で、何らかのオブジェクトを指しています。
つまり`オブジェクト == オブジェクト`の形です。
このとき、この構文は次の構文と同じだとRubyが判断します。

```ruby
a.==(b)
```

これはオブジェクトaの`==`メソッドを引数bをつけて呼び出すことに他なりません。
ですから、二項演算子`==`は実は左辺のオブジェクトのメソッド（メソッド名）になります。
その意味はオブジェクトごとに決まっています。
概念的には「等しい」ですが、オブジェクトごとに「等しい」の具体的な内容は異なっているわけです。

- 文字列であれば、文字列の内容が等しい
- 配列であれば、配列の各要素に対し`==`メソッドの結果が等しくなっている
- 整数であれば、数値として等しい（同じ数値のオブジェクトはひとつしかないので、この場合はオブジェクトとしても同じ、すなわちオブジェクトIDが等しい）

また、違う種類のオブジェクトを`==`で比較すると、大抵の場合は「等しくない」という結果になります。
しかし、絶対異なるというわけでもなく、`1.0==1`は実数と整数という異なるオブジェクト間の比較ですがtrueになります。
これは、実数の`==`の定義の中で、引数が整数の場合はそれを実数に変換するなどの比較可能な形にして調べているからです（実装を確認したわけではない）。

代入`=`はメソッドではなく、再定義できません。
なぜなら、代入の左辺はオブジェクトではなく、変数だからです。
変数自身にはメソッドはありません。

```ruby
a = 10
a = "abc"
```

1行目は変数aに整数10を代入しています。
2行目の左辺aは整数オブジェクト10を指してはいますが、代入先はそのオブジェクトではなく、変数a自身です。
aはオブジェクト10から切り離されて、新たに文字列オブジェクト"abc"を指すようになります。

これと似ていますが、次のプログラムは意味が異なります。

```ruby
a.x = 10
```

`a.x`は変数ではありません。
変数`a`の指すオブジェクトのxメソッドの返した値になります。
ですから、この文では`=`が代入のイコールだとするとエラーになるはずです（代入はオブジェクトにはできない）。

しかし、エラーにならないこともあるのです。
それはオブジェクトに`x=`というメソッドが定義されている場合です。
この文は糖衣構文で次のように置き換えられます。

```ruby
a.x=(10)
```

元の式では`a.x`と`=`の間に半角空白があったのですが、糖衣構文の適用でこの空白は消えてしまいます。
`a.x`ではなく`a.x=`がひとまとまりです。
一般に空白は区切りを表しますが、これは例外ということになります。

左辺のオブジェクトに`x=`メソッドが定義されていなければエラーになり、つぎのようなメッセージが現れます。

```
undefined method `x=' for （左辺のオブジェクト）
```

エラーの内容は「`x=`メソッドが左辺のオブジェクトにない」です。
このことからも、糖衣構文の置き換えが行われた後にエラーが発生したことがわかります。

## 再定義できる演算子

次の演算子は再定義することができます。
再定義はオブジェクトのメソッドとして行います。

```
|  ^  &  <=>  ==  ===  =~  >   >=  <   <=   <<  >>
+  -  *  /    %   **   ~   +@  -@  []  []=  ` ! != !~
```

`+@`と`-@`は単行演算子の`+`と`-`を表します。
メソッド定義をする場合はアットマークをつけた名前を使います。

これらの演算子の意味は、それぞれのオブジェクトのメソッドで確認します。
例えば、`<<`については各オブジェクトで次のような意味で使われます。

- Integer（整数）では「左ビット・シフト」
- Array（配列）では「破壊的な要素追加」
- String（文字列）では「破壊的な文字列追加」
- IO（入出力）では「オブジェクトを文字列化して出力」
- Method（メソッド）では「メソッドを合成したProc」
- Proc（手続き）では「手続きを合成したProc」

演算子そのものには確定した意味がないことに注意してください。
演算子の意味を決めるのは各オブジェクトのメソッド定義です。

逆に再定義できない演算子は

```
=  （自己代入） ?:  ..  ...  not  &&  and  ||  or  ::
```

です。

`=`は再定義できませんが、`data=`のようにメソッド名の最後につけることは可能です。

これらの再定義できない演算子は言語の制御構造で使われます。
これらの演算子も使い方が一通りでない場合があります。
ドキュメントでは一箇所に演算子の意味をまとめて書いているのではなく、それぞれのトピックの中で説明されています。
つまりドキュメントのあちこちにばらばらに書かれています。

## 再定義の例

ここでは、2次元ベクトルのクラスを定義して、和と差を再定義してみましょう。

```ruby
class Vec
  def initialize(x=0, y=0)
    @x = x
    @y = y
  end
  def x
    @x
  end
  def y
    @y
  end
  def +(other)
    Vec.new(@x+other.x, @y+other.y)
  end
  def -(other)
    Vec.new(@x-other.x, @y-other.y)
  end
  def to_s
    "(#{@x}, #{@y})"
  end
end

a = Vec.new(1,2)
b = Vec.new(-2,4)
print "#{a} + #{b} = #{a+b}\n"
print "#{a} - #{b} = #{a-b}\n"
```

Vecは2次元ベクトルを表すクラスです。
x成分、y成分をそれぞれ@x、@yのインスタンス変数に保持します。
このオブジェクトは一度生成された後は値を変えないことにしています。
このような変更不可のオブジェクトはイミュータブル（immutable）といいます。
変更可能はミュータブル（mutable）です。

オブジェクトを生成する時に、引数をつけます。
引数によってベクトルの各成分が決まります。

メソッドは、各成分を返す、和と差を計算して新たなVecオブジェクトを返す、オブジェクトを文字列にする、です。

演算子+と-を再定義しています。
この再定義のメソッドでは、otherというパラメータが演算の相手方を表しています。
otherはVecオブジェクトを想定しています。
それ以外のオブジェクトを引数にしてメソッドが呼ばれたときの対策ないので、エラーが起こります。
本当はその対策が必要ですが、ここではあくまで例ですので単純化しました。

to\_sメソッドは文字列の式展開の中で（背後で）使われます。
もしこのメソッドを定義してなければ、式展開の結果が恐ろしいものになってしまうでしょう。

実行してみます。

```
(1, 2) + (-2, 4) = (-1, 6)
(1, 2) - (-2, 4) = (3, -2)
```

きちんと計算できていることがわかります。

演算子、とくに四則計算の演算子は数学用ですので、その他のオブジェクトを定義するときにはあまり使われないかもしれません。
しかし、文字列結合に+が用いられているように、演算子がそのメソッドのイメージに合うこともあるでしょう。
そのときには、ぜひ再定義してみてください。