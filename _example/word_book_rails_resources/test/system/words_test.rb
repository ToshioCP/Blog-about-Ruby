require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  test "flow from the root through every action" do
    visit root_url
    assert_selector "h1", text: "単語帳"
    fill_in "search", with: "."
    click_on "検索"

    assert_selector "h1", text: "単語検索結果"
# - ルートにアクセスしindexアクションへ（以下「アクション」を省略）
# - 正規表現「.」で検索してsearchへ
# - tallをクリックしてshowへ
# - 「追加」ボタンを押してnewからcreateを経てshowへ
# - 「変更」ボタンを押してeditからupdateを経てshowへ
# - 「削除」ボタンを押してdeleteからindexへ
  end
end
