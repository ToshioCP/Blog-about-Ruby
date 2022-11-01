---
layout: posts
title: GemとBundler
description: GemとBundler
category: library
date: 2022-10-13 23:05:12 +0900
---
Rubyのライブラリ管理システムのRubygemsとコマンドgemおよびbundlerについて説明します。

- [Rubygems](#rubygems)
- [gemコマンド](#gemコマンド)
- [bundlerコマンド](#bundlerコマンド)
- [まとめ](#まとめ)

## Rubygems

Rubyではライブラリのことをgem（英語の発音はジェムで意味は「宝石」）といいます。
そして、Rubyのライブラリ管理システムをRubygemsといいます。
gemは`https://rubyges.org`に保管されています。
このウェブサイトをブラウザで開くと、gemの検索やgem情報の確認ができます。

[Rubygems](https://rubygems.org/)

このウェブサービスはRuby on Railsで作られているそうです。

ここからgemをダウンロード・インストールする仕組みもRubygemsと呼ばれ、Rubyに標準で添付されています。
狭い意味ではこれがRubygemsです。

Rubygemsのドキュメントは充実しています。
まずは[Rubyのドキュメント](https://docs.ruby-lang.org/ja/3.1/library/rubygems.html)から見てください

ここにgemコマンドの使い方が書かれています。
[Rubygems全般のドキュメント（英語）](https://guides.rubygems.org/)はRubygemsのウェブサイトにあります。

gemをホームページで探し、ダウンロードするだけならRubyのドキュメントの解説だけで十分です。

## gemコマンド

さきほどのリンク先を参照してもらえば十分なので、このセクションではgemコマンドを使い、インストール、実行までの実例を示します。
なお、自前のgemを作ることもできますが、ここでは扱いません（それができるくらいなら「徒然Ruby」を読む必要ないですよね）。

rakというプログラムを例にとります。
このプログラムはカレントディレクトリ以下のファイルからパターンに対応する文字列が含まれるファイルを検索し、該当行を表示するプログラムです。
Unixのgrepに似ていますが、あるディレクトリの下にあるファイルすべてを対象にするのが特長です。

gemのインストールには「gemコマンド」に動作の指定「install」をつけ、「gem名」を続けます。
rakのインストールの場合は「gem install rak」です。

```
$ gem install rak
Fetching rak-1.4.gem
Successfully installed rak-1.4
Parsing documentation for rak-1.4
Installing ri documentation for rak-1.4
Done installing documentation for rak after 0 seconds
1 gem installed
$
```

これだけでインストールが完了します。
gemには、大別してライブラリと実行プログラムがあります。
rakは実行プログラムです。
rakを実行すると、赤でハイライトされた検索結果が表示されます。

<div style="padding: 7px;border: 3px solid #e8e8e8; background: #fbfbfb">
$ rak webrick<br/>
<span style="color:red;">Gemfile</span><br/>
<span style="margin-left: 3ch;">6|gem "<span style="color:red;">webrick</span>"</span><br/>
$
</div>

この例では、カレントディレクトリのGemfileの6行目に「gem "webrick"」という行があることを示しています。

rakが不要になり、アンインストールしたい場合は次のようにします。

```
$ gem uninstall rak
```

他の操作については、Rubyのドキュメントを参考にしてください。

## bundlerコマンド

gemに似たコマンドにbundlerがあります。
これもRubyに同梱されています。
bundlerはカレントディレクトリに書かれたGemfileに基づいてgemをインストールします。
Gemfileには複数のgemを指定でき、一度にインストールできるので、gemコマンドよりも便利です。
bundlerは、特に多くのgemを必要とする大規模なプログラムに向いています。
個人が小さいプログラムを作る場合にはgemコマンドで十分です。

gemのバージョンについても指定ができます。
特定の古いバージョンのgemでないと動作しないプログラムの場合は、Gemfileにそのgemのバージョンも記しておきます。
これは特に公開プログラムでは重要で、新しいバージョンのgemに対応するまでの間のつなぎとして用いられます。

多くの人にとってはbundlerを使うのはRuby on Railsでウェブサイトを作るような場合ではないでしょうか。
自作のプログラムでbundlerを使うケースはまだまだ少ないように思います。
そこで、ここではRailsに似ているが、それよりは簡単なアプリケーションであるJekyllを例にとってbundlerを説明したいと思います。
なお、Jekyllは静的なウェブサイトを作成するためのプログラムです。
Jekyllの詳細は「[はじめてのJekyll + GitHub Pages](https://toshiocp.github.io/jekyll-tutorial-for-beginners/)」を参照してください。

まず、Jekyllをインストールします。

```
$ gem install jekyll
```

ここでは、sampleという名前のサイトを作りましょう。
「jekyll new」でサイトの元になるファイル群を作成します。

```
$ jekyll new sample
$ cd sample
$ ls
404.html  Gemfile  _config.yml  _posts  about.markdown  index.markdown
```

新しくディレクトリsampleが作られ、その下にいくつかのファイルが作られています。
その中にはGemfileもあります。
Gemfileは少し長いので、ここではコメント部を省略して掲載します。

```ruby
source "https://rubygems.org"
gem "jekyll", "~> 4.2.2"
gem "minima", "~> 2.5"
group :jekyll_plugins do
  gem "jekyll-feed", "~> 0.12"
end
platforms :mingw, :x64_mingw, :mswin, :jruby do
  gem "tzinfo", "~> 1.2"
  gem "tzinfo-data"
end
gem "wdm", "~> 0.1.1", :platforms => [:mingw, :x64_mingw, :mswin]
gem "http_parser.rb", "~> 0.6.0", :platforms => [:jruby]
```

OSがLinuxでRubyがCRuby（Cで書かれたRuby、MRI--Matz' Ruby Implementationとも）の場合、`platforms`が指定されている部分とjrubyが指定されている部分は実行されないので、それを除くと3つのgemが指定されます。
ローカルでJekyllを動かす場合、webrickというgemが必要です。
webrickはRuby3.0から標準ライブラリから削除されましたので、Rubygemsからのインストールが必要です。
Gemfileをエディタで開き、webrickを追加します。

```ruby
gem "webrick"
```

Gemfileに書かれたgemをインストールするには、bundlerを用います。
コマンドラインから「bundle install」としてください。
bundlerを起動するためのコマンド名は「bundle」です。

```
$ bundle install
Fetching gem metadata from https://rubygems.org/............
Resolving dependencies...
Using public_suffix 5.0.0
Using bundler 2.3.23
... ... ...
... ... ...
Using jekyll 4.2.2
Using jekyll-feed 0.16.0
Using jekyll-seo-tag 2.8.0
Using minima 2.5.1
Bundle complete! 8 Gemfile dependencies, 32 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

途中省略しましたが、全部で32個のgemがインストールされました（下から2行目を見てください）。
gemの数が多くなったのは「Gemfileで指定したgemが依存するgem」も含めてインストールしたからです。

インストール時に新しいファイル「Gemfile.lock」が作られます。
このファイルはインストール時点で「Gemfile指定バージョンの範囲での最新のgem」を確定したものです。
プログラムはこのファイルに基づいてバージョンが選ばれ、実行されます。
実行は「bundle exec プログラム名」という形で行います。
例えばjekyllでサーバーを起動するには「bundle exec jekyll serve」です。
単に「jekyll serve」とすると、Gemfile.lockのバージョンに無関係にgemが起動されます。
通常はその時点での最新版が使われます。
プログラムによっては旧版でないと動かない場合もあるので、Gemfile.lockのバージョンを守ることが大事です。
したがって、「bundle exec」は必ず付けてください。

```
$ bundle exec jekyll serve
Configuration file: /home/ユーザディレクトリ... .../sample/_config.yml
            Source: /home/ユーザディレクトリ... .../sample
       Destination: /home/ユーザディレクトリ... .../sample/_site
 Incremental build: disabled. Enable with --incremental
      Generating... 
       Jekyll Feed: Generating feed for posts
                    done in 0.417 seconds.
 Auto-regeneration: enabled for '/home/ユーザディレクトリ... .../sample'
    Server address: http://127.0.0.1:4000/
  Server running... press ctrl-c to stop.
```

下から2行目に「ローカルホストの4000番ポート」にサーバアドレスが設定されていることが記されています。
ブラウザ（Google Chrome、FirefoxやMicrosoft Edgeなど）を立ち上げ、「`http://localhost:4000/`」または同じことですが「`http://127.0.0.1:4000/`」を開くと、次のような画面が現れます。

![sampleのローカルホストの画面](/assets/images/jekyll_local.png)

- 「bundle exec jekyll serve」でローカルホスト（あなたが動かしているコンピュータのこと）がウェブサーバとなった
- ローカルのアドレス（上記のアドレス）にJekyllが作成したページが存在する
- ブラウザがそれをアクセスすると、上記の画面が表示される

※　ローカルというのは自分の動かしているコンピュータ、リモートというのはそこから離れて動いている別のコンピュータを指します。
また、ホストとはネットワーク上のコンピュータのことです。
ネットワーク上のサーバもコンピュータであり、ホストと呼ばれます。
サーバにアクセスするコンピュータはクライアントと呼ばれますが、これもホストです。

Jekyllはこのようにウェブサイトを作るプログラムです。
表示されたのはJekyllが作ったサンプルページです。
通常は、ユーザが更にカスタマイズしてウェブページを作ります。

- Jekyllでは静的なウェブサイトを構築できる
- JekyllはMarkdownをサポートする＝＞HTMLを書くよりも作業量が少なくて住む
- JekyllはLiquidをサポートする＝＞ウェブサイトの内容をLiquidプログラムで構成できる
- Jekyllのプラグインを使うとより少ない作業量でウェブサイトを構築できる

詳しくは「[はじめてのJekyll + GitHub Pages](https://toshiocp.github.io/jekyll-tutorial-for-beginners/)」を参照してください。

サーバを止めるには「CTRL+C」を押します。

「bundle install」と「bundle exec」が最も良く使うコマンドです。
その他には、gemをGemfileの範囲でアップデートする「bundle update」も使うことがあるでしょう。
bundlerについての更に詳しい情報は[Bundlerのホームページ](https://bundler.io/)を参照してください。

Railsを用いたウェブアプリケーションを作成する場合、Gemfileの内容を変更、追加しなければならないこともあると思います。
その時はbundlerのウェブサイトにある「Gemfileの書き方」（Learn More Gemfiles）を参考にしてください。

## まとめ

今回はRubyのライブラリをgemと呼ぶこと、そしてgemのインストール方法を紹介しました。
これを読んでお分かりいただけたと思いますが、gemのインストールは簡単です。
あとは、どんなgemがあるのか、という知識が必要なだけです。

直接Rubygemsで調べるのも良いですが、[Bestgems](https://bestgems.org/)というgemのランキングサイトも参考になると思います。
今日の時点でのダウンロード1位がbundlerですが、これはbundlerがRuby同梱であることを考えると不思議な気がします。
また、人気のRailsですが40位とかなり低いのも不思議です。

ダウンロード上位のgemは有用なことが多いと思われますので、時々眺めてみると良いでしょう。
