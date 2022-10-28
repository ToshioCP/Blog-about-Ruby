require "test_helper"

class WordsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get words_index_url
    assert_response :success
  end

  test "should get append" do
    get words_append_url
    assert_response :success
  end

  test "should get change" do
    get words_change_url
    assert_response :success
  end

  test "should get delete" do
    get words_delete_url
    assert_response :success
  end

  test "should get list" do
    get words_list_url
    assert_response :success
  end
end
