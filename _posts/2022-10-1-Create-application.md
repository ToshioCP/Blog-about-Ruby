---
layout: posts
title: アプリ制作、インストール、テスト
description: アプリ制作、インストール、テスト
category: 基本事項
date: 2022-10-1 21:06:59 +0900
---
だいぶRubyの説明は進みましたから、このあたりでアプリを作る上でのポイントを述べたいと思います。
そのために、簡単な電卓プログラムを作り、GitHubにアップロードしたので、参考にしてください。

[calc](https://github.com/ToshioCP/calc)

- [ファイル名で起動する方法](#ファイル名で起動する方法)
- [コマンドへの引数の処理](#コマンドへの引数の処理)
- [インストーラ](#インストーラ)
- [テスト](#テスト)
- [Readme.md](#readmemd)
- [GitとGitHub](#gitとgithub)

## ファイル名で起動する方法

Rubyプログラムは

```
$ ruby ファイル名
```

で起動できるのですが、「ruby」と入力するのは煩わしいものです。
アプリ作成中は仕方がないとしても、完成したアプリはファイル名だけで起動したいですね。
それを実現するには、次の3行をファイル名の先頭に付けます。

```
#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby
```

お呪いのようなものだと考えて、コピペしても構いません。
一応説明すると、まず1行目の`#!`はシバン（shebang）と呼ばれ、Unix系のOSではそのスクリプトを実行するプログラムを指定します。
この場合は「`/bin/sh`によってこのファイルを実行する」のですから、シェルスクリプトとしての実行になります。
（`/bin/bash`ではなく`/bin/sh`となっているのは、システムによってはbash以外のシェルが使われているかもしれないからです。
`/bin/sh`はいろいろなシェル共通の呼び出しを提供します）。

2行目はシェルのコマンドで、`exec`はそのシェルのプロセスで（新規プロセスを生成せずに）コマンドを実行する、というものです。
`$0`は起動されたファイル名（スクリプトファイルのファイル名）、`$@`は引数すべてを表します。
これから、もしこのスクリプトファイルのファイル名が`copy`でコマンドラインから次のように呼ばれたとすると、

```
copy file1 file2
```

まず、`/bin/sh/が起動され、2行目が実行されます。
2行目は

```
ruby -x copy file1 file2
```

とコマンドラインから入力するのとほぼ同じことになります。

`-x`はrubyのオプションで、「スクリプトを読み込む時に、`#!'で始まり, "ruby"という文字列を含む行までを読み飛ばす」というものです。
このことにより、最初の3行（#!/bin/sh〜#!ruby）が読み飛ばされ、4行目からrubyプログラムが実行されます。

Unix系OSのシバングは指定されたファイルを実行するので、

```
#!/usr/bin/ruby
```

でも良いように思われますが、これだとまずい場合もあります。
最もありそうなケースはrbenvでインストールしたrubyです。
rubyは$HOME/.rbenv以下に保存されるので、/usr/bin/rubyでは呼び出せません。
（$HOMEはユーザのホームディレクトリで、シェルからは`~`でも参照できます）。
このrubyはシェルから呼ぶことにより起動できるので、いったんシェルを起動してからrubyを起動する、という面倒なやり方が必要なのです。

## コマンドへの引数の処理

Unix系OSではコマンドラインの構成が

```
コマンド 引数1 引数2 ・・・・
```

となっています。
Rubyでは、引数は`ARGV`という配列に代入されます。
例えば

```
$ ruby_echo Hello world
```

とコマンド`ruby_echo`が呼ばれたとき、

- `ARGV[0]`には文字列"Hello"が代入されている
- `ARGV[1]`には文字列"world"が代入されている

となります。
コマンドラインでは半角空白が引数の区切り文字になります。
区切り文字はARGVの中には入りません。
もし、空白も入れたいというときには、シングルクォートを用います。

```
$ruby_echo 'Hello world'
```

この場合は`ARGV[0]`に文字列"Hello world"が代入されます。
引数は1個ということになります。

引数が何個あるかは配列の要素の数を返すメソッドsizeを使います。
`ARGV.size`が引数の数です。

ruby\_echoのプログラムは簡単です。

```ruby
#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby

print ARGV.join(' '), "\n"
```

配列ARGVの各要素をjoinメソッドで繋げて文字列にします。
そのとき要素の区切りには、引数' '（半角空白）が用いられます。

## インストーラ

作成例として、電卓プログラムcalc.rbを考えてみましょう。
このプログラムをコマンド名calcでインストールしたいとします。
その場合は`$HOME/bin`以下にファイルを置き、実行属性をつければよいのです。
FileUtilsモジュールを使うのが便利です。

```ruby
require 'fileutils'
include FileUtils

def install
  cp "calc.rb", "#{Dir.home}/bin/calc"
  chmod 0755, "#{Dir.home}/bin/calc"
end
```

- Dir.homeはユーザのホームディレクトリ（$HOMEと同じ）を返すメソッド
- cpはFileUtilsモジュールのメソッドで、ファイルをコピーする。
- chmodはFileUtilsモジュールのメソッドでファイルの属性を指定する。
0755は8進整数を表す。このファイル属性は
  - 所有者は読み、書き、実行可
  - グループメンバーは読み、実行可で、書き込不可
  - その他ユーザは読み、実行可で、書き込不可
となる

実行属性をつけないと、ファイル名での起動はできません。
以上のようにインストールするとコマンドラインから

```
$ calc
```

で起動できるようになります。

アプリケーションを作るときには、インストーラも作っておきましょう。
また、アンインストーラ（インストーラに含め、オプションで切り替えても良い）も入れておくと良いです。
GitHubのCalcにはインストーラ`install.rb`が添付されているので参考にしてください。

上記ではユーザ領域へのインストールでしたが、他のLinuxユーザにも使えるようにするには/usr/local/binにインストールします。
このときは管理者権限が必要なので、Ubuntuなどではsuコマンドを使います。
例えば

```
$ su ruby install.rb
```

のように起動します。

しかし、システム領域にインストールする必要はほとんどないと思います。

## テスト

Rubyの標準のテスト・スートはminitestです。
名前はミニですが、結構大きいプログラムで、ドキュメントの量もあります。
minitestは別の記事で詳しく述べようと思いますが、ここではポイントを絞って書きたいと思います。

テストプログラムはRubyで書きます。
calcのテストは次のような感じになります。

```ruby
require 'minitest/autorun'
require_relative 'lib_calc.rb'

class TestCalc < Minitest::Test
  def setup
    @calc = Calc.new
  end
  def teardown
  end

  def test_lex
    assert_equal [[func.to_sym,nil],[:'(',nil],[:id,"x"],[:')',nil]], @calc.lex("#{func}(x)")
... ... ...
... ... ...
  end

  def test_parse
    assert_output("100\n"){@calc.run("10*10")}
... ... ...
... ... ...
  end
end
```

- `minitesti/autorun`をrequireで取り込む
- テストしたいファイル`lib_calc.rb`はテストプログラムと同一ディレクトリにある。
取り込みには`require_relative`を使う
- テスト用のクラス（ここではTestCalcという名前になっている）を`Minitest::Test`のサブクラスとして定義する
- クラス内にはsetup、teardown、各テスト用のメソッドがある。
  - setup＝＞各テストの前に準備作業をするためのメソッド
  - teardown＝＞各テスト後の後始末をするためのメソッド
- テスト用のメソッドには`test_`というプレフィックスをつける
- assert_equial A, B は「Aが正常に機能したときの結果のオブジェクト」「Bが実行結果のオブジェクト」で、それらが一致すればテストを通過したことになり、一致しないとメッセージが出力される。
前者をexpected（期待される結果）、後者をactual（実際に行った結果）としてメッセージに書き込まれる
- assert_output(A){ B }はAが標準出力への期待される出力、ブロックは実行メソッド。
メソッド（B）を実行した出力とAが一致すればテスト通過、一致しなければメッセージが出力される

テストがすべて通ると次のように出力されます。

```
$ ruby test.rb
Run options: --seed 43869

Running:

..

Finished in 0.006940s, 288.1909 runs/s, 8501.6308 assertions/s.
2 runs, 59 assertions, 0 failures, 0 errors, 0 skips
$ 
```
ドットはテスト項目、つまりTestCalcの各メソッドを表しています。
エラーがあると次のようなメッセージが出力されます。

```
Run options: --seed 34278

Running:

.F

Failure:
TestCalc#test_parse [test.rb:24]:
In stdout.
--- expected
+++ actual
@@ -1,2 +1,2 @@
-"100.0
+"100
 "



rails test test.rb:23



Finished in 0.010876s, 183.8891 runs/s, 4505.2836 assertions/s.
2 runs, 49 assertions, 1 failures, 0 errors, 0 skips
```

Failureはテストで失敗したことを示しています。
この他にErrorが出ることがありますが、それはプログラムを実行した時にエラーがあったことを意味しており、テストの結果ではありません。
上記ではexpectedがマイナスでactualがプラスで表されているので、「100.0」になることを期待してテストしたが、実際は「100」になったということを表しています。

すべての場合をテストするのは無理なので、典型的な例をテストすることになります。
プログラムのエラーは境界で起こりやすいです。
例えば正負が問題になるプログラムでは0が境界です。
「（変数）>= 0」を使わなければいけないのに「（変数）> 0」を使うといったバグは0以外ではフェイル（失敗）が起こりません。
ですから「境界をテストする」ことは非常に重要です。

GitHubのcalcには`test.rb`というテストプログラムがついているので参考にしてください。

なお、minitestを使うことを考えると、トップレベルだけでプログラムを作るのは得策ではありません。
仮にインスタンス変数をトップレベルで使うと、minitestからは参照できなくなります。
それは、テストのためのメソッドがTestCalcクラスで定義されているので、テスト時のインスタンスはトップレベルではないためです。
ですから、上の例のように、アプリの中でクラスを定義し、それをsetupメソッドでインスタンス生成して使うのが良い方法です。

## Readme.md

簡単なドキュメントは付けておくべきです。
仮に公開しなくても、将来自分自身が見直す時に役に立ちます。
2週間別の仕事をすると、元の仕事内容を思い出すのに結構な時間がかかります。
そのときにドキュメントは役に立つでしょう。

GitHubに公開する場合はReadme.mdのようなファイル名をつけることになっています。
拡張子のmdはMarkdown形式を表します。
Markdownはhtmlと比べ格段に見やすく、書きやすいので勧められる形式です。
Markdownの説明は、次の記事を参考にしてください。


[はてなブログのMarkdown徹底解説](https://toshiocp.com/entry/2022/07/09/235226)

ただし、はてな記法などのはてな独自の記法はGitHubでは使えません（GitHubのMarkdownはGFM）。

## GitとGitHub

プログラムを公開するならばGitHubは無料で、機能が充実していて、有力な選択肢です。
GitHubとGitについては「はじめてのJekyll+GitHub Pages」の中に書かれていますので、以下を参考にしてください。

[はじめてのJekyll + GitHub Pages](https://toshiocp.github.io/jekyll-tutorial-for-beginners)

- 第3章 GitHub pagesクイックスタート
- 第7章　Gitの使い方
- 第10章　GitをSSHで使う方法

が参考になります。
このうち第10章のSSHで使う方法は知らなくても大丈夫です。

今回はアプリ開発の実際を見てきましたが、いかがだったでしょうか。
簡単なアプリで良いのでぜひ作ってGitHubにあげてみてください。
作れば作るほどプログラミングのレベルは上がります。
