---
layout: posts
title: yield、Enumerable、リフレクション
description: yield、Enumerableモジュール、リフレクション
category: クラスとモジュール
date: 2022-9-25 12:10:26 +0900
---
ブロック付きメソッドの作り方を説明します。

## eachメソッド

ブロック付きメソッドの代表格であるeachが何をしているかを考えてみます。

```ruby
[10,20,30].each do |x|
  print x, "\n"
end
```

これを実行すると

```
10
20
30
```

と表示されます。
メソッドeachは何をしているのでしょうか

- 配列の要素から10を取り出し、10をパラメータ`x`に代入してブロックを実行する
- 配列の要素から20を取り出し、10をパラメータ`x`に代入してブロックを実行する
- 配列の要素から30を取り出し、10をパラメータ`x`に代入してブロックを実行する

ブロックはメソッドのようなものですから、順に10,20,30を引数にブロックを呼び出していることになります。
eachの動作をプログラムにすると、およそ次のようなものになります。

```ruby
x = 10
while x <= 30
  print x, "\n" # iを引数にブロックを実行
  x += 10
end
```

あるいは、whileループを使わなくても

```ruby
x=10; print x, "\n" # 10を引数にブロックを実行
x=20; print x, "\n" # 20を引数にブロックを実行
x=30; print x, "\n" # 30を引数にブロックを実行
```

でもeachの動作を表すことができます。

「xを引数にブロックを実行」という命令は、Rubyでは`yield(x)`と書きます。
つまり、「yieldはブロックを呼び出す命令」です。
yieldにはパラメータをつけることができます。

## eachとyieldの実例

ここでは、ユーザデータのオブジェクトを考えてみます。
そのオブジェクトには

- ユーザ番号
- ユーザ名
- メールアドレス
- 誕生日

を記録することにします。
ユーザ番号はオブジェクト生成時に一意になるような番号を自動的に振ることにし、書きかえはできないようにします。
その他のデータは書き換え可能にします。

```ruby
class User
  @@count = -1
  attr_reader :id
  attr_accessor :name, :email, :birth_date
  def initialize
    @id = @@count += 1
  end
  def each
    yield("id", @id)
    yield("name", @name)
    yield("email", @email)
    yield("birth_date", @birth_date)
  end
end

user = User.new
user.name = "Toshio Sekiya"
user.email = "abcdefg@example.com"
user.birth_date = "YYYY/MM/DD"
user.each{|k,v| print "#{k}: #{v}\n"}
```

- @@countのように、@が2つついた変数は「クラス変数」という。
クラス変数はクラスに保存されていて、そのインスタンスからアクセス可能（共有することになる）
- @@countは-1に初期化された後には、インスタンスが生成されるたびに（initializeメソッドで）1だけ増やされていく
- `attr_reader :id`は読み出しのみ可能なインスタンス変数@idを定義する（前回の記事で説明済み）
- `attr_accessor :name, :email, :birth_date`は読み書き可能な変数@name、@email、@birth\_dateを定義する（後述）。
- eachメソッドでは、@idから@birth\_dateまでの「変数名と値」を引数にyieldを使ってブロック実行している
- userにUserのインスタンスを代入
- 名前、email、誕生日を代入
- eachメソッドで、変数名と値をプリント

`attr_accessor`は次のプログラムと同等の働きをします。

```ruby
def name
  @name
end
def name=(s)
  @name = s
end
... ... ...
以下emailとbirth_dateも同様
```

最後の行でeachを呼び出し、呼ばれたeachの中でyieldがブロックが呼ぶ、という複雑さは慣れないとわかりにくいと思います。
繰り返し流れを追って、理解してください。

なお、例からわかるように、yieldのパラメータの数とブロックのパラメータの数は一致していなければなりません。
 
## EnumerableモジュールとEnumeratorクラス

eachメソッドから様々なメソッドを作り出すことができます。
例えば、Userクラスにmapメソッドを定義するには次のようにします。

```ruby
# eachからmapを作る例
class User
  def map
    a = []
    each do |k, v|
      a << yield(k, v)
    end
    a
  end
end

p user.map{|k,v| [k,v]}.to_h
```

class User〜endでUserクラスの定義を追加しています。
このように、クラス定義は何度でもできます（このことから既存のクラスにもメソッド追加が可能です）。

mapの定義ではeachメソッドだけを使っていることがわかります。
最後の1行では、mapを使って「項目名とその値の配列」の配列を作り、更にハッシュに変換しています。
実行すると次のようにハッシュの中身が表示されます。

```
{"id"=>0, "name"=>"Toshio Sekiya", "email"=>"abcdefg@example.com", "birth_date"=>"YYYY/MM/DD"}
```

map以外にも

- inject たたみこみ演算
- find 検索
- sort 整列。ただし各要素に`<=>`が定義されていることが必要
- select 検索して一致する要素すべての配列を返す

など様々なメソッドがeachだけから作成可能です。
このようなメソッドを集めたモジュールがEnumerableです。

UserクラスがEnumerableをインクルードすれば、mapなどを定義しなくても使えるようになります。

UserクラスがEnumerableをインクルードしていなくても、mapなどを使えるようにする別の方法があります。
それはEnumeratorというラッパークラスを使う方法です。

`user.to_enum`によって、userオブジェクトを元にしたEnumeratorオブジェクトを作ることができます。
なお、`to_enum`はObjectクラスで定義されたインスタンス・メソッドなので、すべてのクラスはObjectの子孫ですから、`to_enum`を持っています。
中身はuserなのですが、EnumeratorオブジェクトはEnumerableモジュールをインクルードしているので、mapなどのメソッドを使うことができます。

```ruby
p user.to_enum.map{|k,v| [k,v]}.to_h
```

実行すると

```
{"id"=>0, "name"=>"Toshio Sekiya", "email"=>"abcdefg@example.com", "birth_date"=>"YYYY/MM/DD"}
```

さきほどと同じハッシュが表示されます。
まとめると、eachを定義してあるクラスには

- Enumerableモジュールをインクルードするとmapなどの様々なメソッドが使えるようになる
- `to_enum`でEnumeratorオブジェクトにしてもmapなどの様々なメソッドが使えるようになる

ということです。

## 引数の展開、block\_given?メソッド

Userクラスをリファクターしましょう。
最も問題なのはyieldを@idから@birth\_dateまで個別に行っていることです。
もしUserの項目を追加したり削除したりすると、この部分も変更しなければなりません。
そこで、attr\_accessorの引数にする項目名（変数名）を配列で保持し、その配列を使ってyieldするようします。
これにより、項目名の変更は配列の変更だけで済みます。

もうひとつは、eachメソッドが引数なしで呼ばれた時にEnumeratorオブジェクトを返すオプションをつけます。

```ruby
class User
  include Enumerable

  @@count = -1
  @@accessors = ["name", "email", "birth_date"]
  attr_reader :id
  attr_accessor *@@accessors
  def initialize
    @id = @@count += 1
  end
  def each
    if block_given?
      yield("id", @id)
      @@accessors.each do |a|
        yield(a, eval("@#{a}"))
      end
    else
      self.to_enum
    end
  end
  def to_h
    map {|k, v| [k.to_sym, v]}.to_h
  end
end

user = User.new
user.name = "Toshio Sekiya"
user.email = "abcdefg@example.com"
user.birth_date = "YYYY/MM/DD"
user.each{|k,v| print "#{k}: #{v}\n"}
user1 = User.new
user1.name = "Jeaou Robinson"
user1.email = "xyz@example.co.uk"
user1.birth_date = "yyyy/mm/dd"
user1.each{|k,v| print "#{k}: #{v}\n"}

p user.to_h
p user1.each
```

- Enumerableモジュールをインクルードすることにより、mapなどのメソッドが追加される
- @@accessors配列を、attr\_accessorの引数を要素にして作成する。
要素はシンボルでなく文字列を使う（attr\_accessorの引数はシンボル、文字列の両方が可）
- attr\_accessorの引数に配列を直接与えることはできない。
配列の要素を展開するために、配列の前にアスタリスク（`*`）をつける。
一般にメソッド呼び出し`m(a,b,c)`と`m(*[a,b,c])`は同じになる
- block\_given?はそのメソッド（上のプログラムではeachメソッド）がブロック付きで呼ばれればtrue、そうでなければfalseを返す
- ブロック付きならば、@idは個別にyieldし、@@accessorsの各項目についてはeachで繰り返しyieldする
- yieldの第2引数はその変数の値なので項目名の前に@をつけてインスタンス変数名にし、evalで値を取得している。
evalは与えられた文字列をRubyコードとして実行するメソッド
- ブロックがなければ、to\_enumメソッドでEnumeratorオブジェクトを返す
- to\_hメソッドで各項目名とその値を組みとするハッシュを返す

このプログラムを実行すると

```
id: 0
name: Toshio Sekiya
email: abcdefg@example.com
birth_date: YYYY/MM/DD
id: 1
name: Jeaou Robinson
email: xyz@example.co.uk
birth_date: yyyy/mm/dd
{:id=>0, :name=>"Toshio Sekiya", :email=>"abcdefg@example.com", :birth_date=>"YYYY/MM/DD"}
#<Enumerator: #<User:0x00007f1f7a737be8 @id=1, @name="Jeaou Robinson", @email="xyz@example.co.uk", @birth_date="yyyy/mm/dd">:each>
```

と表示されます。
最後の2行でto\_hメソッドと引数なしeachメソッドが期待通りに動いていることが確認できます。

## リフレクション

ユーザを表現するオブジェクトはインスタンス変数で各項目を表す方法（この記事のUserクラスのように）とハッシュを使う方法が考えられます。
ハッシュを使う場合は

```ruby
toshio = {}
toshio[:id] = 0
toshio[:name] = "Toshio Sekiya"
toshio[:email] = "abcdefg@example.com"
toshio[:birth_date] = "YYYY/MM/DD"

p toshio #=> {:id=>0, :name=>"Toshio Sekiya", :email=>"abcdefg@example.com", :birth_date=>"YYYY/MM/DD"}
```

となります。

これらの違いは何でしょうか？

- ハッシュでは項目名がハッシュのキー名
- Userクラスは項目名が変数名

ハッシュは実行しているプログラムの扱う対象です

- キー名の一覧を取り出すことができる（keysメソッド）
- キーと値の組を追加できる（[ ]=メソッド）
- キーから値を取得できる（[ ]メソッド）
- キーと値の組を削除できる（deleteメソッド）

これらと同等のことはC言語でも行うことができます。

```c
struct hash { char *key; char *value; };
```

この構造体をリストでつなげてRubyのハッシュと同等のデータ構造を実現し、それをコントロールする関数を定義すれば良いのです。
実装が面倒ですが、可能だということです。

これに対して変数名は基本的に実行しているプログラムの扱う対象ではありません。

- 変数名の一覧を取り出す
- 変数を追加する
- 変数名からその値を取得する
- 変数を削除する

C言語を例に取ると、変数の管理はコンパイラがシンボルテーブルで行うのであって、実行プログラムは管理しません。
したがって、上記のような操作、特に変数の追加と削除（これはシンボルテーブルへの追加と削除を意味する）は実行プログラムでは不可能です。

Rubyではどうでしょうか？
Rubyにはevalなどがあるので実行プログラムからこれらを行うことができます。

- 変数名の一覧を取り出す（instance\_variablesメソッドなど）
- 変数を追加する（attr\_accessorメソッドをクラスに適用など）
- 変数名からその値を取得する（evalメソッド）
- 変数を削除する（remove\_instance\_variableメソッド）

このように、Rubyでは実行プログラムがRubyの状態（変数のシンボルテーブルなど）を知ることができ、アクセスもできます。
これを「リフレクション」といいます。
レフレクションを使って更にUserクラスのプログラムを書き直してみましょう。

```ruby
class User
  include Enumerable

  @@count = -1
  attr_reader :id
  attr_accessor :name, :email, :birth_date
  def initialize
    @id = @@count += 1
  end
  def each
    if block_given?
      instance_variables.each do |iv|
        yield(iv.to_s.slice(1..-1), eval(iv.to_s))
      end
    else
      self.to_enum
    end
  end
  def to_h
    map {|k, v| [k.to_sym, v]}.to_h
  end
  def show
    each do |k, v|
      print "#{k}: #{v}\n"
    end
  end
end

user = User.new
user.name = "Toshio Sekiya"
user.email = "abcdefg@example.com"
user.birth_date = "YYYY/MM/DD"
user1 = User.new
user1.name = "Jeaou Robinson"
user1.email = "xyz@example.co.uk"
user1.birth_date = "yyyy/mm/dd"

User.attr_accessor(:location)
user.location = "Japan"
user.show
user1.show
```

- @@successors変数は使わない。
eachメソッドの定義では、代わりにinstance\_variablesメソッドでインスタンス変数の一覧を取り出している
- showメソッドは定義されている変数と値の一覧を表示
- 下から4行目はattr\_accessorメソッドをUserクラスに対して実行して@location変数を読み書き可で追加している
- 次の行でuserオブジェクトにlocationを追加
- userオブジェクトを表示（locationまで表示される）。
eachメソッドでinstance\_variablesを使った効果が現れている
- user1オブジェクトを表示（@locationが定義されていないので、locationは表示されない）。
詳しく説明すると、`User.attr_accessor(:location)`は@locationの参照と代入のメソッドを定義しているだけで、@location自身を定義しているのではない。
@locationは初めて代入されるときに同時に定義される。
例えば、userオブジェクトで@locationが定義されたのは、`user.location = "Japan"`が実行されたときである。
user1では@locationの代入は行われていないので未定義である

実行すると次のようになります。

```
id: 0
name: Toshio Sekiya
email: abcdefg@example.com
birth_date: YYYY/MM/DD
location: Japan
id: 1
name: Jeaou Robinson
email: xyz@example.co.uk
birth_date: yyyy/mm/dd
```

Userクラスはいじると面白いのですが、実用上はどうなのでしょうか？
ハッシュを使うほうがプログラマーにとって易しいので、保守性も高いような気がします。
わざわざ難しくするのもどうなのか？
ただ、アクセサーの構文（user.location = "Japan"など）は読みやすく分かりやすいですね。
一長一短かもしれません。

リフレクションについて書いておいてこういうのも何ですが、

**リフレクションを使い過ぎて難しくしてはいけません**

プログラムはそもそもやっかいで面倒なもの。
余計な難しさは余計な時間を費やすことになります。