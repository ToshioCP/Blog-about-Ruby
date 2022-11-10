require "test_helper"

class WordFlowsTest < ActionDispatch::IntegrationTest
  test "flow from new to show through create" do
    # access to the new action
    get new_word_url
    assert_response :success
    # access to the create action
    post words_url, params: { word: { en: "stop", jp: "止まる", note: "" } }
    assert_response :redirect
    follow_redirect!
    # redirect to the show action
    assert_response :success
    assert_equal "単語を保存しました", flash[:success]
    assert_select "ul.list-group" do
      assert_select "li", "stop"
      assert_select "li", "止まる"
      assert_select "li", ""
    end
  end

  test "flow from edit to show through update" do
    # access to the edit action
    word = words(:tall)
    get edit_word_url(word)
    assert_response :success
    # access to the update action
    patch word_url(word), params: { word: { en: "tall", jp: "背の高い", note: "How tall is she?\n彼女はどのくらい背がありますか？" } }
    assert_response :redirect
    follow_redirect!
    # redirect to the show action
    assert_response :success
    assert_select "ul.list-group" do
      assert_select "li", "tall"
      assert_select "li", "背の高い"
      assert_select "li", "How tall is she?\n彼女はどのくらい背がありますか？"
    end
  end

  test "flow from delete to index" do
    # access to the delete action
    word = words(:house)
    delete word_url(word)
    assert_response :redirect
    follow_redirect!
    # redirect to the index action
    assert_response :success
    assert_select "h1", "単語帳"
  end
end
