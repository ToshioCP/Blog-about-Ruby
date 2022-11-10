require "test_helper"

class WordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get words_url
    assert_response :success
  end

  test "should get show" do
    get word_url(words(:tall))
    assert_response :success
    assert_select "nav a", {text: /変更|削除/, count: 2}
    assert_select "nav a.disabled", {text: /変更|削除/, count: 0}

    id = words(:tall).id+words(:house).id
    get word_url(id)
    assert_response :success
    assert_select "nav a.disabled", {text: /変更|削除/, count: 2}
    assert_equal "データベースにはid=#{id}のデータは登録されていません", flash.now[:alert]
  end

  test "should get new" do
    get new_word_url
    assert_response :success
  end

  test "should create word" do
    assert_difference("Word.count") do
      post words_url, params: { word: { en: "stop", jp: "止まる", note: "" } }
    end
    assert_redirected_to word_path(Word.last)
  end

  test "should get edit" do
    get edit_word_url(words(:tall))
    assert_response :success
  end

  test "should update word" do
    word = words(:tall)
    patch word_url(word), params: {word: {en: "tall", jp: "背が高い", note: ""}}
    assert_redirected_to word_path(word)
  end

  test "should delete word" do
    word = words(:tall)
    assert_difference("Word.count", -1) do
      delete word_url(words(:tall))
    end
    assert_redirected_to words_path
  end

  test "should get search" do
    get words_search_url, params: {search: "."}
    assert_response :success
  end
end
