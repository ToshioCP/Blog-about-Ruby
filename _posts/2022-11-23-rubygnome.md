---
layout: posts
title: Ruby/GTK3とRuby/GTK4 -- Rubyとグラフィック
description: Ruby/GTK3とRuby/GTK4によるグラフィック
category: Ruby/GTK4
date: 2022-11-23 21:00:00 +0900
---

今回はGTK 3とGTK 4をRubyで使うライブラリについて書きたいと思います。

## GTKと「Rubyで動くGTK」とは

GTKはオープンソースのGUIライブラリです。
オリジナルはCで書かれており、Linuxで開発されました。
その後Windowsでも動くようになり、また言語もPythonやPerlなどで使えるようになりました。

GTKの現在の安定版はGTK 4（バージョン4.8.2）です。
以前の版がGTK 3でその最新版は3.24.35です。
GTK 4がリリースされて2年以上経ちますので、これから使うとしたらGTK 4になると思います。
ですが、今回はGTK 3とGTK 4の両方を試してみました。

RubyでGTKを動かすプロジジェクトはGitHub上で開発が進んでいます。

[ruby-gnome/ruby-gnome](https://github.com/ruby-gnome/ruby-gnome)

このGitHubの中でgtk3とgtk4の両方のgemが開発されています。
gemのバージョンは4.0.3となっています。
ドキュメントが少ないため、どの程度まで開発が進んでいるのかは良くわかりませんでした。

とにかく、試すしかないか、という感じです。

## インストール

gemコマンドでインストールします。
gem名は「gtk3」と「gtk4」です。
どちらか一方をインストールすれば十分ですが、私は両方を試してみることにしましたので、2つともインストールします。

gtk4のインストール

```
$ gem install gtk4
Fetching red-colors-0.3.0.gem
... ... ...
Fetching gtk4-4.0.3.gem
... ... ...
... ... ...
13 gems installed
```

gtk3のインストール

```
$ gem install gtk3
Fetching gtk3-4.0.3.gem
... ... ...
... ... ...
2 gems installed
```

## ドキュメント

Ruby/GTK3とRuby/GTK4をまとめてRuby/GTKと書くことにします。
Ruby/GTKはGTKの機能をRubyで実現しようとするもので、GTKへの理解が前提となります。
そこで、GTKのAPIリファランスのリンクを示しておきます。

- [GTK 3](https://docs.gtk.org/gtk3/index.html)
- [GTK 4](https://docs.gtk.org/gtk4/index.html)

GTKに馴染みのない方はこのリファランスの「Additional documentation」にある「Getting started with GTK」をまず読んでください。
ここがGTKのすべての出発点になります（それも難しいかもしれませんが）。
GTK 4については、GitHubレポジトリ[Gtk4-tutorial](https://github.com/ToshioCP/Gtk4-tutorial)、
またはその[HTML版](https://toshiocp.github.io/Gtk4-tutorial/)もあります。

Ruby/GTK自体のドキュメントはありますが、完全ではありません。

- [Ruby/GNOME](https://ruby-gnome.github.io/ruby-gnome/doc/dev/index.html)
- [Ruby/GTK3](https://www.rubydoc.info/gems/gtk3/4.0.3)
- [Ruby/GTK4](https://www.rubydoc.info/gems/gtk4/4.0.3)

例えばGTKのWindowオブジェクトにはそのデフォルトサイズを指定する`gtk_window_set_default_size`という関数があります。
これはRubyのインスタンス・メソッドに相当するものです。
Ruby/GTK4にはこの記載はありませんが、`set_default_size`というRubyメソッドで使うことができます。

想像ですが、Ruby/GTKはこのメソッドをプログラムによる自動生成で作っているのではないでしょうか。
そうであれば、通常のメソッド定義の構文は使っていないことになります。
そして、ドキュメント自体もプログラム（おそらくRDoc）による自動生成ならば、メソッドをドキュメントに拾い出すことはできないでしょう。
この点については、ソースコードを確認できていないのであくまで推測です。

いずれにせよ、ドキュメントにないGTKのメソッドがRubyで使えるかどうかは、実際に試してみるしかありません。

## Hello world

手始めはいつも「Hello world」です。
このプログラムではGTK 3とGTK 4を両方試せるようになっていて、引数に3を入れるとGTK 3にそれ以外ではGTK 4を使うようになっています。

```
$ ruby hello.rb 3 #=> GTK 3を使う
$ ruby hello.rb   #=> GTK 4を使う
```

先にコードを示して、その後説明します。

```ruby
@gtk_version = (ARGV.size == 1 && ARGV[0] == "3") ? 3 : 4

require "gtk#{@gtk_version}"
print "Require GTK #{@gtk_version}\n"

application = Gtk::Application.new("com.github.toshiocp.hello", :default_flags)

application.signal_connect "activate" do |app|
  window = Gtk::ApplicationWindow.new(app)
  window.set_default_size 400,300
  window.title = "Hello"

  label = Gtk::Label.new("Hello World")
  if @gtk_version == 4
    window.child = label
    window.show
  else
    window.add(label)
    window.show_all
  end
end

application.run
```

- はじめに引数を調べ、@gtk_versionに3または4を代入
- `require "gtk3"`または`require "gtk4"`を実行。これによりRuby/GTKが使えるようになる

GTK 3の使い方は徐々に変わってきて、`gtk_application`を使うのが良い方法になってきました。
GTK 4も同じ使う方をしますので、ここではそれにならってプログラムしています。

- Gtk::Applicationオブジェクト（以下アプリケーションという）を生成する
- アプリケーションにはIDをつける。
アプリケーションIDはURLを逆にするようなパターンで書き、世界で他に同一のものがないようにする。
例えばメールアドレスは世界にひとつしかないのでそれを使うことも可能である。
`abc@example.com`というメールアドレスを自分が持っているとする。
アプリケーションIDは`com.example.abc.hello`とすれば良い。
（注：だれでも同じ文字列を使ってアプリケーションを作れるから、このIDが世界中でユニークだということを保証することはできない。
しかしGTKのシステムがアプリケーションIDがユニークであることを前提に作られているので、アプリ制作者がIDの付け方に十分注意を払う必要がある）。
上記の`hello.rb`ではGitHubのIDを用いている
- `:default_flags`は「アプリケーションのデフォルト動作」ということ。
このフラグはGApplication ver2.74から使うようになった。
（[GIO ドキュメント](https://docs.gtk.org/gio/flags.ApplicationFlags.html)）
以前は`:flags_none`を用いていた。
Cでプログラムする場合は「引数がファイル名である（`:handles_open`）」「引数が任意の文字列である（`:handles_command_line`）」などの定数もあるが、Rubyではあまり必要ないかもしれない（Rubyで引数処理できるから・・・正確ではないかも・・・）
- アプリケーションが起動され、（`:default_flags`で）アクティブになると`activate`シグナルが発せられる。
そのシグナルを受けて動作するプログラムを「ハンドラ」という。
シグナルとハンドラをつなぎ合わせるメソッドが`signal_connect`メソッド。
そのメソッドのブロックにハンドラを記述する。
- ハンドラでは、まずApplicationWindowオブジェクトを生成する。
このオブジェクトはアプリケーションと連携したウィンドウで、newメソッドには引数にアプリケーションを与える。
デフォルトサイズを400x300に、タイトル（タイトルバーに表示される文字列）を「Hello」に設定する
- Labelオブジェクトを生成する。
ラベルオブジェクトはウィンドウの中で文字列を表示する。
その文字列をnewメソッドの引数に与える
- GTK 4ではchildメソッドでラベルをウィンドウの子としてつなげる。
画面上ではウィンドウの中にラベルが配置されることになる。
このようにウィンドウ内のオブジェクト（ウィジェットという）の中に別のウィジェットが入り込むとき、外が親、中が子という親子関係が発生する。
この「ウィジェットの親子関係」は「クラスの親子関係」とは異なるものである。
GTK 3ではaddメソッドを使う（GTK 3ではこのような親子関係を作るときコンテナが必要なことがあり、GTK 4よりも複雑）。
- GTK 4ではトップレベルのウィンドウをshowメソッドで表示するだけで良い。
というのは、トップレベルのウィンドウ以外のオブジェクトはデフォルトで「visible（表示）」にプロパティが設定されるからだ。
GTK 3ではデフォルトが「visible」ではないので、`window.show`を使うとウィンドウだけが表示され、ラベルが見えなくなってしまう。
`window.show_all`を使うとウィンドウとその子孫ウィジェットが表示できる。
なお、`window.show`に加えて`label.show`とすればウィンドウ・ラベルともに表示できるが、`show_all`を使うほうが簡単

![Hello world]({{ "/assets/images/hello_gtk.png" | relative_url }})

さて、「Hello world」を表示するだけにもかかわらず、説明がこんなに長くなってしまいました。
考えてみると、その多くの部分はGTKの説明です。
このことはRuby/GTKを使えるようになるには、GTKの理解が重要だということを示しています。
残念ながらGTK 4の日本語の解説資料はほとんどありません。
英語で最も頼りになるのはGTKのドキュメントです。
ですが、それも分かりやすいわけではありません。
GTKは学習コストが高いなあ、と思います。
ただ、それは非常に大きな首尾一貫したシステムだからで、GTKをマスターすればソフトウェアのスキルが格段に上がることは疑いないと思います。

## 電卓

簡単なGUIのプログラムである電卓を作ってみます。
`lib_calc.rb`はGlimmerと同じものを使います。
`calc.rb`だけをGTK対応に変更します。

まず、プログラムを示しましょう。

```ruby
@gtk_version = (ARGV.size == 1 && ARGV[0] == "3") ? 3 : 4

require "gtk#{@gtk_version}"
print "Require GTK #{@gtk_version}\n"

require_relative "lib_calc.rb"

def get_answer a
  if a.instance_of?(Float) &&  a.to_i == a
    a.to_i.to_s
  else
    a.to_s
  end
end

application = Gtk::Application.new("com.github.toshiocp.calc", :default_flags)

application.signal_connect "activate" do |app|
  calc = Calc.new
  window = Gtk::ApplicationWindow.new(app)
  window.default_width = 400
  if @gtk_version == 4
    window.default_height = 120
  else
    window.default_height = 80
  end
  window.title = "Calc"

  vbox = Gtk::Box.new(:vertical, 5)
  window.child = vbox

  hbox = Gtk::Box.new(:horizontal, 5)
  label = Gtk::Label.new("")
  if @gtk_version == 4
    vbox.append(hbox)
    vbox.append(label)
  else
    vbox.pack_start(hbox)
    vbox.pack_start(label)
  end
    
  entry = Gtk::Entry.new
  entry_buffer = entry.buffer
  button_calc = Gtk::Button.new(label: "計算")
  button_clear = Gtk::Button.new(label: "クリア")
  button_quit = Gtk::Button.new(label: "終了")
  if @gtk_version == 4
    hbox.append(entry)
    hbox.append(button_calc)
    hbox.append(button_clear)
    hbox.append(button_quit)
  else
    hbox.pack_start(entry)
    hbox.pack_start(button_calc)
    hbox.pack_start(button_clear)
    hbox.pack_start(button_quit)
  end
    
  button_calc.signal_connect "clicked" do
    label.text = get_answer(calc.run(entry_buffer.text))
  end
  button_clear.signal_connect "clicked" do
    entry_buffer.text = ""
  end
  button_quit.signal_connect "clicked" do
    if @gtk_version == 4
      window.destroy
    else
      window.close
    end
  end

  if @gtk_version == 4
    window.show
  else
    window.show_all
  end
end

application.run
```

![calc]({{ "/assets/images/calc_gtk.png" | relative_url }})

最初のあたりはGTK 3/4両方に対応するための処理、それから`get_answer`は以前と同じメソッドです。
GTKに関するプログラムはapplicationの定義以降です。
activateシグナルのハンドラがプログラムの大部分なのでそこを説明します。

- ウィンドウのデフォルトサイズは幅と高さを別々に定義することができる。
GTK 3とGTK 4では高さの設定が異なるので、分けて定義する
- ボックス・オブジェクトを使う。
ボックス・オブジェクトは縦または横に複数のオブジェクトを並べるためのコンテナ。
縦に並べるときは`:vertical`横に並べるときは`:horizontal`を生成時に引数に渡す。
引数の2番めはオブジェクト間のスペースをピクセル単位で指定する。
ここでは縦に並べるボックスを、1番めがボックス、2番めをラベルにして定義。
内側のボックスは横に並べるボックスで、その中にエントリーと3つのボタンを含める。
GTK 4では`append`メソッドを、GTK 3では`pack_start`メソッドを使ってオブジェクトをボックスに追加していく
- エントリとエントリ内のバッファは別オブジェクトになっていて、それぞれGtk::EntryクラスとGtk::EntryBufferクラスである。
このプログラムではGtk::EntryBufferオブジェクトをGtk::Entryクラスのbufferメソッドで取り出している。
エントリで編集された文字列はバッファの中に保存されている。
- ボタンがクリックされたときに`clicked`シグナルが発生する。
このシグナルに対するハンドラを定義してそれらを`signal_connect`メソッドで結びつける。
  - 計算ボタンのハンドラでは（１）`entry_buffer`の文字列を取り出し（２）`calc.run`で計算し（３）`get_answer`で文字列化し（４）ラベルのテキストに代入する
  - クリアボタンのハンドラでは、`entry_buffer`の文字列を空文字列にする
  - 終了ボタンのハンドラではトップレベルのウィンドウを閉じる。GTK 4では`destroy`、GTK 3では`close`メソッドを用いる

プログラムが長くなった原因はウィジェットを並べるコマンドを長々と書かなければならなかったからです。
これを解決するためにGTKにはウィジェットを別ファイル（UIファイル）にXMLで書くことができます。
次のセクションではこのことについて述べます。

## ビルダーの使用

ウィジェットの入れ子になった構造をXMLで表したファイルをUIファイルといい、拡張子を`ui`にします。
これを用いると本体のRubyプログラムを簡潔にすることができます。
電卓のUIファイルは次のとおりです。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object id="window" class="GtkWindow">
    <property name="title">Calc</property>
    <property name="default-width">400</property>
    <property name="default-height">200</property>

    <child>
      <object id="vbox" class="GtkBox">
        <property name="orientation">GTK_ORIENTATION_VERTICAL</property>
        <child>
          <object id="hbox" class="GtkBox">
            <property name="orientation">GTK_ORIENTATION_HORIZONTAL</property>
            <child>
              <object id="entry" class="GtkEntry">
              </object>
            </child>
            <child>
              <object id="button_calc" class="GtkButton">
                <property name="label">計算</property>
              </object>
            </child>
            <child>
              <object id="button_clear" class="GtkButton">
                <property name="label">クリア</property>
              </object>
            </child>
            <child>
              <object id="button_quit" class="GtkButton">
                <property name="label">終了</property>
              </object>
            </child>
          </object>
        </child>
        <child>
          <object id="label" class="GtkLabel">
          </object>
        </child>
      </object>
    </child>
  </object>
</interface>
```

最初にXMLの定義を書き、次の行からウィジェットの定義を書きます。
一番外のタグはinterfaceです。
その中にobjectタグでウィジェットを表し、childタグでその親子関係を表します。
propertyタグではオブジェクトのプロパティを定義します。

- objectタグのアトリビュート
  - id ⇒ そのオブジェクトの名前。同じ名前を別のオブジェクトにつけてはいけない。この名前を使ってRubyプログラムでオブジェクトを取り出す
  - class ⇒ そのオブジェクトのGTK上のクラス「GtkWindow」や「GtkButton」のようにGtkというプレフィックスがつく
- propertyタグはそのオブジェクトのプロパティを設定する
  - そのオブジェクトが持つプロパティを調べるにはGTKのドキュメントを参照する。例えばGtkButtonには`label`プロパティがある。
GTK 4のドキュメントであれば「[GtkButtonクラスのプロパティの説明](https://docs.gtk.org/gtk4/property.Button.label.html)」を参照する
  - nameアトリビュートにはそのプロパティ名を入れる。GTKのドキュメントでは「GtkButton:label」となっているが、コロンの後の「label」のみを指定する
  - プロパティには文字列、数字、真偽などがある。数字は100のように文字列でその数字を書けばよく、真偽はtrue/falseなどを書く（ye/noなどもOK）

XMLファイルを見ると、ウィジェットの親子関係が反映されていることが分かると思います。
注意するのは、ボックス内に並べるウィジェットひとつひとつに`<child>`タグが必要なことです。
まとめてひとつの`<child>`タグにすることはできません。

UIファイルを読み込んでオブジェクトをメソッドが組み立ててくれるので、Ruby内では記述の必要なオブジェクト（たとえばシグナルを設定するオブジェクト）だけをUIファイルから取り出すだけですみます。
ボックスのようなものは取り出す必要がありません。
そのおかげでプログラムはかなりすっきりします。

```ruby
@gtk_version = (ARGV.size == 1 && ARGV[0] == "3") ? 3 : 4

require "gtk#{@gtk_version}"
print "Require GTK #{@gtk_version}\n"

require_relative "lib_calc.rb"

def get_answer a
  if a.instance_of?(Float) &&  a.to_i == a
    a.to_i.to_s
  else
    a.to_s
  end
end

application = Gtk::Application.new("com.github.toshiocp.calc", :default_flags)

application.signal_connect "activate" do |app|
  calc = Calc.new

  builder = Gtk::Builder.new(file: "calc.ui")
  window = builder["window"]
  entry = builder["entry"]
  entry_buffer = entry.buffer
  button_calc = builder["button_calc"]
  button_clear = builder["button_clear"]
  button_quit = builder["button_quit"]
  label = builder["label"]

  window.set_application(app)
  if @gtk_version == 3
    window.default_height = 80
  end

  button_calc.signal_connect "clicked" do
    label.text = get_answer(calc.run(entry_buffer.text))
  end
  button_clear.signal_connect "clicked" do
    entry_buffer.text = ""
  end
  button_quit.signal_connect "clicked" do
    if @gtk_version == 4
      window.destroy
    else
      window.close
    end
  end

  if @gtk_version == 4
    window.show
  else
    window.show_all
  end
end

application.run
```

UIファイルの取り込みにはGtk::Bulderクラスを使います。
Builderクラスのオブジェクトを生成するときにUIファイル内のウィジェットも生成されます。
そこからウィジェット（オブジェクト）を取得するには`[]`メソッドを使います。
ちょうどハッシュのキーを使って値を取り出すようにします。

UIファイルではGtkApplicationWindowを記述することができません。
なぜなら、それを生成するにはApplicationオブジェクトが必要だからです。
そこで、UIファイルではGtkWindowオブジェクトを記述します。
これは一般的なウィンドウ・オブジェクトです。
そのため、ウィンドウとアプリケーションを繋げなければなりません。
それをするのが、GtkWindowクラスの`set_application`メソッドです。

それ以外はUIファイルを使わないcalcのプログラムと同じです。

UIファイルはウィジェットが多く複雑なときにとても便利です。
本体のプログラムが冗長になるのを防いでくれます。

## GTKでできること

Ruby/GTKがどこまでできるかはもっと使ってみないとわかりませんが、ここまでのところを見るとかなりGTKのつくりを反映していると思いました。
GObject IntrospectionというGTKのCライブラリなどを他の言語で使えるようにするバインディングソフトがあり、Ruby/GTKもそれを使っています。
ということは、ライブラリのRubyへの翻訳はプログラムを使って自動化されているということです。
おそらく、GTKでできることはRubyでもほとんどできるのかもしれません。

例えばGNOMEの標準エディタであるGEdit、あるいはお絵描きソフトのGimpはGTKで書かれています。
ということは相当完成度の高いアプリを書くことができるということです。
それらのソフトはCで書かれていますが、Rubyでも同程度のものの作成が期待できます。

GTKのドキュメントを見ると数多くのウィジェットが用意されています。
GTKの全体を理解するのにはとても時間がかかりますが、得られるものも大きいはずです。

あとはRuby/GTKのドキュメントの整備が課題だと思います。
GTKもドキュメントが分かりにくいと考える人が多いですが、Ruby/GTKの場合は更に深刻で、ほとんどのメソッドの記述が無い状態です。

これはマンパワーの問題が大きいのだと思います。
大企業ではプロジェクトを推進するのに十分な人材を充てることができますが、オープンソースではそうでないケースが多いです。
そうなると優れたソフトウェアほど開発に注力しなければならず、ドキュメントがなかなか充実しません。
特に、易しい記述のガイドが少なくなりがちで、ソフトウェアを使う人の裾野が広がらないのです。

プロジェクトの開発においては、ソフトウェア自体の開発以外にドキュメントの整備やソフトウェア普及の活動などトータルな計画が必要だと思います。