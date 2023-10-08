---
layout: posts
title: 単項マイナスと構文解析
description: Unary minus and parsing
category: library
date: 2023-10-8 22:00:00 +0900
---

- [単項マイナスとは](#単項マイナスとは)
- [単項マイナスと括弧](#単項マイナスと括弧)
- [括弧なし単項マイナスを許容する場合のBNF](#括弧なし単項マイナスを許容する場合のbnf)
- [calcの場合](#calcの場合)

# 単項マイナスとは

単項マイナスとは、式のなかに使われるマイナスで、その数字の符号を変えるためのものです。
例えば「−２」は２の符号をマイナスに変更する演算です。
「ー」には「引き算」を表す場合もありますが、単項マイナスの演算はそれではありません。
例をあげてみましょう。

- 「ー２」・・・単項マイナス
- 「３−２」・・・引き算のマイナスで、単項マイナスではない

単項マイナスと引き算のマイナスは異なる演算子ですから、違う文字を割り当てれば混乱しないのですが、習慣上同じ文字を使うことになってしまいました。

# 単項マイナスと括弧

単項マイナスには括弧をつけるという数式記述上の習慣があります。

```
2+(-3)
2-(-3)
2*(-3)+6/(-3)
```

これは括弧なしで「２＋−３」と書いたときに、それが「２＋（−３）」とは分かりにくいという、人間の感覚上の問題があるからです。
実は、単項マイナスの優先順位を加減乗除よりも高くしておけば、曖昧にはなりません。

```
2+-3=2+(-3)=-1
2--3=2-(-3)=2+3=5
2*-3+6/-3=2*(-3)+6/(-3)=(-6)+(-2)=-8
```

人間と違って、コンピュータは見た目でなく、論理的に式を解析しますから、括弧なしでもきちんと式を解釈してくれます。
我々人間にとって、これは慣れの問題だと思うので、括弧なしの単項マイナスOKと決めてしまっても大丈夫なのではないでしょうか。

なお、数式の記述において単項マイナスの括弧を省略できるケースがあります。
それは数式の最初に単項マイナスがくる場合です。
例えば「−２＊３＋４」という式を考えてみましょう。
乗算と加算では乗算が優先するものとします。つまり、掛け算「＊」は足し算「＋」よりも前に計算します。
この式は2通りに解釈できますが、どちらも同じ結果になります。

```
-2*3+4 = (-2)*3+4 = -6+4 = -2
-2*3+4 = -(2*3)+4 = -6+4 = -2
```

このように解釈が分かれても結果が同じになるので、括弧を省略して良いわけです。
これは3項を足す場合に括弧がなくて良いのと同じ理由です。

```
1+2+3 = (1+2)+3 = 3+3 = 6
1+2+3 = 1+(2+3) = 1+5 = 6
```

このように加算は、左結合または右結合のいずれをとっても結果が同じになり、そのことから括弧を無しで書くことが許されます。

# 括弧なし単項マイナスを許容する場合のBNF

括弧なし単項マイナスを許容する式を構文解析するためのBNFを考えてみましょう。
なお、BNFや構文解析については前回の記事を参照してください。

<https://toshiocp.github.io/Blog-about-Ruby/library/Racc/>

演算子の優先順位を定義しておけば、極めて単純なBNFになります。
以下のファイルをsample3.yとして保存します。

```
class Sample3
  token NUMBER
  prechigh
    nonassoc UMINUS
    left '*' '/'
    left '+' '-'
  preclow
  options no_result_var
rule
  expression  : expression '+' expression { val[0] + val[2] }
              | expression '-' expression { val[0] - val[2] }
              | expression '*' expression { val[0] * val[2] }
              | expression '/' expression { if val[2] != 0 then val[0] / val[2] else raise "Division by zero." end }
              | '-' expression { -val[1] }
              | '(' expression ')' { val[1] }
              | NUMBER
end

---- header

---- inner

def lex(s)
  @tokens = []
  until s.empty?
    case s[0]
    when /[+\-*\/()]/
      @tokens << [s[0], s[0]]
      s = s[1..-1] unless s.empty?
    when /[0-9]/
      m = /\A[0-9]+/.match(s)
      @tokens << [:NUMBER, m[0].to_f]
      s = m.post_match
    else
      raise "Unexpected character."
    end
  end
end

def next_token
  @tokens.shift
end

---- footer

sample = Sample3.new
print "Type q to quit.\n"
while true
  print '> '
  $stdout.flush
  str = $stdin.gets.strip
  break if /q/i =~ str
  begin
    sample.lex(str)
    print "#{sample.do_parse}\n"
  rescue => evar
    m = evar.message
    m = m[0] == "\n" ? m[1..-1] : m
    print "#{m}\n"
  end
end
```

Raccを使ってコンパイルします。

```
$ racc sample3.y
```

すると、sample3.tab.rbというRubyのソースファイルができます。
これは、BNFに沿って計算するRubyプログラムです。
実行してみましょう。

```
$ ruby sample3.tab.rb
Type q to quit.
> 1+-2
-1.0
> 1--2
3.0
> 2*-3
-6.0
> -2*-3
6.0
> q
$
```

単項マイナスは高優先順位の演算子なので、乗除の計算に先立って計算しています。
括弧のない「１−−２」のような式は、違和感がありますが、文法的には曖昧さなしに定義できているわけです。
 
# calcの場合

GitHubに登録してあるCalcの場合は、式の先頭の単項マイナス以外は括弧をつける必要があります。
このBNFは上に書いたBNFよりもその分複雑になっています。

<https://github.com/ToshioCP/calc>

このBNFの中から、四則と単項マイナスの部分だけを取り出して、若干の手直しを加えると次のようになります。

```
expression  : expression '+' primary { val[0] + val[2] }
            | expression '-' primary { val[0] - val[2] }
            | expression '*' primary { val[0] * val[2] }
            | expression '/' primary { if (val[2] != 0.0) then val[0] / val[2] else raise("Division by zero.") end }
            | '-' primary  =UMINUS { -(val[1]) }
            | primary
primary     : '(' expression ')' { val[1] }
              | NUM
```

Primaryという要素には単項マイナスがないので、式の第2項以降の括弧なし単項マイナスはシンタックス・エラーになります。
数式の書き方にPCを合わせるためにPrimaryという要素が入った分複雑になっていますね。
