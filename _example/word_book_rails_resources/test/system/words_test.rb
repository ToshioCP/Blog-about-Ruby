require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  test "flow from the root through every action" do
    # ルートにアクセス＝＞indexアクションへ
    visit root_url
    assert_selector "h1", text: "単語帳"

    # searchアクションへ
    fill_in "search", with: "."
    click_button "検索"

    assert_selector "h1", text: "単語検索結果"
    ["tall","高い","house","家"].each do |s|
      assert_text s
    end

    # newアクションへ
    click_link "追加"

    fill_in "word[en]", with: "stop"
    fill_in "word[jp]", with: "止まる"
    fill_in "word[note]", with: "The machine stopped.\n機械が止まった。\n"
    wc = Word.count

    # createアクションへ
    click_button "作成"

    # showアクションへリダイレクト
    assert_text "単語を保存しました"
    assert_equal 1, Word.count-wc
    ["stop","止まる","The machine stopped.","機械が止まった。"].each do |s|
      assert_text s
    end

    # editアクションへ
    click_link "変更"

    fill_in "word[jp]", with: "止める"
    fill_in "word[note]", with: "I stopped speaking.\n私は話すのをやめた。\n"

    # updateアクションへ
    click_button "変更"

    # showアクションへリダイレクト
    ["stop","止める","I stopped speaking.","私は話すのをやめた。"].each do |s|
      assert_text s
    end
    wc = Word.count

    # deleteアクションへ
    accept_confirm do
      click_link "削除"
    end

    # indexアクションに戻る
    assert_text "単語を削除しました"
    assert_equal -1, Word.count-wc
    assert_selector "h1", text: "単語帳"
  end
end
