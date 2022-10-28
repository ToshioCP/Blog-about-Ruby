require 'minitest/autorun'
require_relative 'db.rb'

class TestDB < Minitest::Test
  def test_db
    File.stub(:exist?, true) do
      CSV.stub(:read, [["pen","ペン"],["pencil","鉛筆"]]) do
        @db = DB.new
      end
    end
    assert_equal([["pen","ペン"]], @db.list("^pen$"))
    assert_equal([["pen","ペン"],["pencil","鉛筆"]], @db.list("pen"))
    @db.append("circle","円")
    assert_equal([["circle","円"]], @db.list("cir"))
    @db.change("circle","円周")
    assert_equal([["circle","円周"]], @db.list("cir"))
    @db.delete("pen")
    assert_equal([["pencil","鉛筆"], ["circle","円周"]], @db.list("."))
  end
  def test_csv
    File.write("test.csv",<<~CSV)
    pen,ペン
    pencil,鉛筆
    CSV
    @db = DB.new("test.csv")
    @db.append("circle","円")
    @db.change("circle","円周")
    @db.delete("pen")
    @db.close
    assert_equal("pencil,鉛筆\ncircle,円周\n",File.read("test.csv"))
    File.delete("test.csv")
  end
end
