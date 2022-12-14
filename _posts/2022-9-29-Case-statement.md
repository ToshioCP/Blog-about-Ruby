---
layout: posts
title: case文
description: case文の特徴と使い方
category: Procオブジェクト
date: 2022-9-29 12:49:20 +0900
---
if〜elsif〜・・・〜else〜endは皆さん良く使うでしょうか？
これは場合分けで良く使われる方法です。
これと同様の制御構造にcase文があります。
Cのswitch文に似ていますが、より強力な機能を持っています。
if-else-endよりも高い能力があるといえます。

#### case文の使い方

case文は次のような構造で使います。

```
case [式]
[when 式 [, 式] ...[, `*' 式] [then]
  式..]..
[when `*' 式 [then]
  式..]..
[else
  式..]
end
```

- caseの次にある「式」に対してwhenの次の「式」（またはその並びのうちのどれか）が一致したときthen以下が実行される。
最初に一致したwhen節があれば、残りのwhen節の比較、実行は行われず、case文全体の次（endの先）に実行が進む
- whenの式との比較は`===`メソッドを使う（`==`ではない）。
`===`メソッドのレシーバはwhen節の式の値となるオブジェクトである。
case文の後の式は`===`メソッドの引数となる
- どのwhen節にも一致しなければelse節が（あれば）実行される
- then後の式を次行以下に書く場合はthenを省略できる

これより、次のcase文とif-else文はほぼ同等です。

```ruby
case x
when 1 then p "x is 1."
when 2 then p "x is 2."
else p "x is not 1 or 2."
end

if 1 === x then p "x is 1."
elsif 2 === x then p "x is 2."
else p "x is not 1 or 2."
end
```

なお、when節の式の前にアスタリスク（`*`）を付けると、式は展開されます。

```
when *[1,2,3] => when 1,2,3 となる
```

case文のような構造を条件分岐ともいいます。
条件分岐はプログラムで最も良く現れる構造です。

#### ==と===の違い

`==`と`===`はオブジェクトごとにメソッドとして定義されています。
ほとんどのメソッドの祖先であるObjectクラスでは、`===`は`==`の別名になっていますので、その子孫クラスで`===`を独自に定義していなければ`===`と`==`は同じ動作をします。
`===`が`==`と違うのはビルトイン・クラスでは次のものです。

- Methodクラス。
`==`はオブジェクトとして等しいかどうかを返す。
`===`は右辺を引数にメソッドオブジェクトを実行した結果を返す
- Moduleクラス。
`==`は同じモジュールかどうかを返す。
`===`は右辺がそのモジュールのサブクラス（子だけでなく子孫すべて）のインスタンスであるときtrueを返す。
すなわち、`A===b`と`b.kind_of?(A)`は同じ値を返す。
なお、ClassクラスはModuleのサブクラスで`===`メソッドを継承しており、同様に使うことができる
RefinementクラスもModuleのサブクラスで`===`メソッドを継承しているが、このクラスを使うのはライブラリなどに限ると思われる
- Procクラス。
`==`はオブジェクトとして等しいかどうかを返す。
同じ手続きを表すProcオブジェクトでも異なるインスタンスはfalseになる。
`p proc{|x| x*x} == proc{|x| x*x} #=> false`。
実際問題として`==`はほとんど役に立たない。
`===`は右辺を引数にProcオブジェクトを実行した結果を返す。
Methodクラスの実装と考え方は全く同じ
- Rangeクラス。
`==`は同じ範囲を表していればtrueを返す。
すなわち、それぞれの端が同じ（`==`）であり、端の含み方が同じ（`..`なのか`...`なのか）ときにtrue。
`===`は引数がRangeオブジェクトの範囲の中にあればtrue。
- Regexpクラス。
`==`は正規表現として同じであればtrueを返す。
`===`は引数の文字列またはシンボルがマッチすればtrueを返す。
if文では良く`=~`が用いられるが、`=~`と`===`はほとんど同じ（ただ返し値は異なる）。

`===`はcase文専用です。
ですので、完全なイコールでなく、マッチに近いメソッドになっています。

特にProcは非常に柔軟なマッチを可能にしています。
Methodも同様ですが、Procの方がよく使われるのではないかと思います。

#### 引数のチェック（クラスのwhen節）

Rubyの変数は任意のオブジェクトを代入できます。
これは変数自体には型がないということです。
そのため、コンパイル時にメソッドの引数の型をチェックすることができません。

※　Rubyはソースを中間コードにコンパイルしてから実行しています

C言語は変数に型があり、パラメータに対しても型を指定できます。

```c
int square (int x) {
  return x*x
}
```

このCの関数のパラメータは整数型です。
コンパイル時にこの関数を整数型以外の引数で呼び出している文があれば、エラーになります。

Rubyでは、このようなチェックは実行時に行うしかありません。
メソッドの最初に引数のオブジェクトがどのようなクラスのオブジェクトかを調べます。
次の例は引数を2乗して返すメソッドです。

```ruby
# 引数を2乗して返すメソッド
def square x
  case x
  when Numeric
    x*x
  else # impossible to calculate, return nil
    return nil
  end
end

p square("abc") #=> nil （文字列は数字でない）
p square(2) #=> 4
p square(1.2) #=> 1.44
p square(Complex("1+2i")) #=> (-3+4i) 複素数も計算できる
p square(Rational("2/3")) #=> (4/9) 分数（有理数）も計算できる
```

数字のクラスInteger（整数）、Float（浮動小数点数）、Complex（複素数）、Rational（有理数）はすべてNumeric（数）のサブクラスです。
`when Numeric`の節では、上記の4つのオブジェクトであるかをひとつのチェックで済ましています。
`else`（それ以外）のときはnilを返すことにします。
これは積極的なエラー対策ではなく、呼び出し側にエラー処理を任せるやり方です。

squareを呼び出したとき、文字列ではnilが返り、整数、浮動小数点数、複素数、有理数では2乗された値が返されています。

このような引数のクラスチェックは特にライブラリでは重要です。
ライブラリの作成者と使用者は異なるのが普通であり、作成者に予想外の使われ方をするかもしれません。
そのためこのようなチェックは非常に重要になります。

#### 引数のチェック（Procオブジェクトのwhen節）

Procオブジェクトを使うと複雑な条件を作ることができます。
次の例は配列の各要素を2乗するメソッド`square_elements`です。

各要素を2乗するだけなら、配列のmapメソッドで簡単に実現できますが、要素に数以外のものが入っているとエラーが起こります。
そこで、配列の要素がすべてNumericのサブクラスのインスタンスかどうかを調べます。
そのためにProcオブジェクトを使います。

```ruby
@is_array_of_Numeric = lambda do |a|
  return false unless a.instance_of? Array # lambdaではreturnで手続きオブジェクトを抜けることができる
  b = a.map{|e| e.kind_of?(Numeric)}.uniq #要素のクラスの配列を作り、重複を除く
  case b.size
  when 0 then false # 空の配列だった
  when 1 then b[0] # true(Numericクラス)かfalse（そうでない）を返す
  else        false # Numericとそうでない要素が混じっていた
  end
end

def square_elements a
  case a
  when @is_array_of_Numeric
    a.map{|x| x*x}
  else
    a
  end
end

p square_elements([1,2,3]) #=> [1, 4, 9]
p square_elements([1.0, 2,Complex("2+3i"),Rational("5/7")]) #=> [1.0, 4, (-5+12i), (25/49)]
p square_elements(["a","b","c"]) #=> ["a", "b", "c"]
p square_elements([[1,2],[3,4],[5,6]]) #=>[[1, 2], [3, 4], [5, 6]]
p square_elements([[1,"2",3.0]]) #=> [[1, "2", 3.0]]
```

インスタンス変数（@つき変数）をProcオブジェクト名に使っているのは、メソッド定義の中で参照できるようにするためです。
型チェックはかなり複雑です

- 引数が配列でない＝＞false
- 引数が空の配列＝＞false
- 引数の要素がすべてNumericのサブクラスのインスタンス＝＞true
- 引数の要素にNumericのサブクラス以外が混ざっている＝＞false

これをメソッドの中で書くこともできますし、例のようにメソッドの外でProcオブジェクトにすることもできます。
もちろん、メソッドの中でProcオブジェクトを生成しても良いのですが、メソッドがコールされるたびにProcオブジェクトが生成され、効率が悪くなります。
このチェックが複数のメソッドで必要ならば、このようにメソッド外でProcオブジェクトを作るのが有効なやり方です。

#### 字句解析（正規表現のwhen節）

字句解析は、主にプログラミング言語の処理系で行われます。
例えば、次のようなRubyプログラムをrubyが処理することを考えてみましょう。

```ruby
ab = 10 * cd
```

このとき、これを次のように解析します。

|文字列|タイプ|
|:--------|:------|
|ab|識別子|
|=|等号|
|10|整数|
|*|掛け算|
|cd|識別子|

この表はruby処理系の実際の動作を説明するものではありません。
あくまでも、字句解析の例として提供するものです。

「識別子」は定数名、変数名やメソッド名などに用いられる文字列です。

字句解析は頭から順にその言語の要素になるもの（トークンという）を取り出し、そのタイプと内容を返していくものです。

ここでは、簡単な電卓プログラムの字句解析を考えてみましょう。
電卓には、変数、整数、四則、代入、表示ができるとします。

|トークン|タイプ|内容|
|:--------|:------|:-----|
|英文字列|:id|変数名|
|数字の文字列|:num|整数|
|+|:'+'|加算記号|
|-|:'-'|減算記号|
|*|:'*'|乗算記号|
|/|:'/'|除算記号|
|(|:'('|左括弧|
|)|:')'|右括弧|
|=|:'='|代入|
|print|:print|表示命令|

全部で10種類のタイプのトークンがあります。
入力文字列を分析し、トークンの列の配列resultを返すメソッド「lex」を作ってみます。

例えば、入力が

```
abc = (2+3)*6
print abc
```

であったとき（つまり文字列`"abc = (2+3)*6\nprint abc\n"`であったとき）、lexの出力は

```
[[:id, "abc"], [:"=", nil], [:"(", nil], [:num, 2], [:+, nil], [:num, 3], [:")", nil], [:*, nil], [:num, 6], [:print, nil], [:id, "abc"]]
```

になります。
字句解析の流れは、入力の最初の文字に対するcase文の条件分岐が主になります。

```ruby
def lex(s)
  result = []
  while true
    break if s == ""
    case s[0]
    when /[[:alpha:]]/
      m = /\A([[:alpha:]]+)(.*)\Z/m.match(s)
      if m[1] == "print"
        result << [:print, nil]
      else
        result << [:id, m[1]]
      end
      s = m[2]
    when /[[:digit:]]/
      m = /\A([[:digit:]]+)(.*)\Z/m.match(s)
      result << [:num, m[1].to_i]
      s = m[2]
    when /[+\-*\/()=]/
      result << [s[0].to_sym, nil]
      s = s[1..-1]
    when /\s/
      s = s[1..-1] 
    else
      raise "Unexpected character."
    end
  end
  result
end

p lex("abc = (2+3)*6\nprint abc\n")
```

- 入力（sに代入される引数の文字列）の1文字目によって場合分けをする
- `/[[:alpha:]]/`は英字（大文字小文字の両方可）にマッチする正規表現。
- 正規表現`/\A([[:alpha:]]+)(.*)\Z/m`において、`\A`と`\Z`はそれぞれ文字列の先頭と末尾にマッチ。
`[[:alpha:]]+`は1文字以上の英字の繰り返しにマッチ。
`.*`は任意の文字の0個以上の繰り返しにマッチ。
`.`はデフォルトでは改行にマッチしないが、正規表現の最後にmオプションがつくときは、改行にもマッチする。
`()`が2箇所にあるので、MatchDataオブジェクトの`[1]`と`[2]`でマッチした部分文字列を参照できる
- 文字列`m[1]`がprintであれば、予約語なので`[:print, nil]`を配列`result`に加える。
printでなければ、変数なので`[:id, m[1]]`、すなわち識別子タイプを表す`:id`と変数名の文字列をセットにしてresultに加える。
`s = m[2]`でsにはマッチした文字列を除いた残りを代入する
- `/[[:digit:]]/`は数字（0-9）にマッチ。
変数のときと同様に数字の並びを取り出し、`:num`タイプと整数値をセットにしてresultに加える
- `/[+\-*\/()=]/`は四則、括弧とイコールのどれかにマッチする。
それぞれの記号を表すシンボルをタイプとし、nilとセットにし、resultに追加する。
`s[1..-1]は先頭の1文字を削除し、次の文字から最後の文字までを返す
- `/\s/`は空白文字にマッチ。
空白文字にはタブや改行も含まれる。
この文字は区切りとしての意味しかない。
resultに付け加えるものは何もない
- それ以外は、電卓で使う文字ではないので、raiseメソッドで例外を発生させ、プログラムを停止する

この例では、正規表現をcase文に使いました。
`===`は正規表現のマッチを意味するので、このようにwhen節に使うことができます。

以上case文を見てきましたが、if-else-end文よりも条件のチェック部分に工夫があります。
これは具体的には`===`メソッドで実現されています。
もし、新たにクラスを作成する時に、そのオブジェクトがwhen節で使える可能性があれば、かならず`===`メソッドを定義してください。

