require "test_helper"

class WordTest < ActiveSupport::TestCase
  test "fixture tall should be read" do
    word = Word.find_by(en: "tall")
    assert_equal "高い", word.jp
    assert_equal "He is tall.\n彼は背が高い。\n", word.note
  end

  test "A valid data should be saved uniquely" do
    w1 = Word.new(en: "room", jp: "部屋", note: "")
    w2 = Word.new(en: "room", jp: "空き", note: "")
    assert w1.save
    refute w2.save
  end

  test "three invalid data should not be saved" do
    w1 = Word.new(en: "", jp: "空き", note: "")
    w2 = Word.new(en: "@@@", jp: "アットマーク", note: "")
    w3 = Word.new(en: "page", jp: "", note: "Turn to page four.\n4ページを開きなさい。")
    [w1, w2, w3].each do |word|
      assert word.invalid?
      refute word.save
    end
  end
end
