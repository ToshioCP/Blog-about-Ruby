---
layout: posts
title: 整数
description: Rubyの整数
category: 基本事項
date: 2022-9-5 10:00:00 +0900
---
ここではRubyの最も基本的なオブジェクトである整数について説明します。

## 整数

Rubyで整数を使うことができます。

```ruby
print 10
print "\n"
```

`example2.rb`に保存して実行すると、

```
$ ruby example2.rb
10
$
```

## 計算

整数は計算できます。

```ruby
print 1+2
print "\n"
print 10-3
print "\n"
print 2*3
print "\n"
print 10/2
print "\n"
print 20/3
print "\n"
```

アスタリスク（'*'）は掛け算の記号です。
実行すると（以下コマンド行は省略します）、

```
3
7
6
5
6
```

- printは計算結果を表示します。
計算の式自体（例えば「1+2」）は表示されません。
- 20/3では、あまりは捨てられます。

カッコを使った複雑な計算も可能です。

```ruby
print (2-4)*(3+5)
print "\n"
```

実行すると`-16`が表示されます。

```
(2-4)*(3+5) = (-2)*8 = -16
```

きちんと計算できていたことがわかります。

## 大きさの上限はない

多くのプログラミング言語では整数の上限がありますが、Rubyにはありません。

```ruby
print 123456789123456789*123456789123456789
print "\n"
```

実行すると

```
15241578780673678515622620750190521
```

計算が合っているかどうか確かめるのは大変なのでやりませんが、エラーにならずに実行されたのは分かると思います。

桁数の多い数字にはコンマをつけますが、Rubyではコンマのかわりにアンダースコア（`_`）を使うことができます。

```ruby
print 1_000_000_000_000
```

一兆が表示されます。

```
1000000000000
```

表示される方にはアンダースコア（あるいはコンマ）が出ないので分かりにくいですね。
表示でコンマをつける方法は今回の内容の範囲を超えるので、本文では扱わず、最後にオマケとして説明します。

なお、アンダースコアは単に無視されているだけなので、数字の先頭以外であればどこに書いても構いません。

## メソッド

Rubyでは整数はオブジェクトの一種です。
オブジェクトはメソッドを持っています。
メソッドはオブジェクト自身に対して、なんらかの操作をします。

例えば、その整数の絶対値をとるメソッドは`abs`です。
絶対値absolute valueの最初の3文字です。
使い方はドットとabsを整数の後ろにつけます。

```ruby
print 20.abs
print "\n"
print -30.abs
print "\n"
```

実行すると

```
20
30
```

が表示されます。

`gcd`は最大公約数（greatest common divisor）を計算するメソッドです。
最大公約数には2つの整数が必要です。
もうひとつの整数は`gcd`のあとにカッコとともに付け加えます。
カッコを省略して半角スペースで区切ることもできます。

```ruby
print 12.gcd(18)
print "\n"
print 20.gcd 30
print "\n"
```

実行すると、

```
6
10
```

と表示されます。

いくつかのメソッドを紹介すると

|メソッド|説明|
|:-----------|:-----|
|lcm(整数)|最大公約数を計算|
|even?|偶数であればtrue奇数であればfalse|
|odd?|偶数であればfalse奇数であればtrue|

## コンマ区切りをつけて数字を表示

この項目の内容は記事のカバーできる範囲を越えているので、参考程度に見てください。

yukichi gemをインストール

```
$ gem install yukichi
```

例えば1234567890をコンマ区切りをつけて表示するには

```ruby
require "yukichi"

print Yukichi.new(1234567890).jpy_comma()
print "\n"
```

実行すると

```
1,234,567,890
```

yukichi gemの中では次のようなメソッドを使っています。

```ruby
1234567890.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1,')
```

これを使えばgemのインストールは不要です。

また、別の方法としては

```ruby
1234567890.digits(1000).reverse.inject{|a,b| a.to_s+','+sprintf("%03d",b)}.to_s
```

でもできます。
最後の方法は私自身の考案です。
