require "csv"

Shoes.app title: "単語帳" do
  @body_index = <<~EOF
    単語帳の使い方
    ・追加＝＞単語を追加
    ・変更＝＞単語を変更
    ・削除＝＞単語を削除
    ・検索＝＞単語を検索（正規表現可）
    ・終了＝＞プログラムを終了
  EOF

  if File.exist? "db.csv"
    @db = CSV.read(@file, headers: false)
  else
    @db = []
  end
  flow do
    @home = para "単語帳", margin_left: 5
    @append = para "追加", margin_left: 20
    @change = para "変更", margin_left: 35
    @delete = para "削除", margin_left: 50
    @edit_line = edit_line "", margin_left: 65
    @search = button "検索"
    @close = button "終了", margin_left: 100 do
      CSV.open(@file, "wb") do |csv|
        @db.each {|x| csv << x}
      end
    end
  end
  stack do
    @title = title "単語帳", margin_left: 30
  end
  @body = stack do
    @body = para @body_index, margin_left: 5
  end
end

