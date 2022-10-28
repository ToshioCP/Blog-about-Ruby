require "csv"

class DB
  def initialize(file='db.csv')
    @file = file
    if File.exist?(@file)
      @db = CSV.read(@file, headers: false)
    else
      @db = []
    end
  end
  def append(e,j)
    @db << [e,j]
  end
  def delete(e)
    i = @db.find_index{|d| e == d[0]}
    @db.delete_at(i) if i # i is nil if the search above didn't find e in @db.
  end
  def change(e,j)
    i = @db.find_index{|d| e == d[0]}
    if i
      @db[i] = [e,j]
    else
      @db <<[e,j]
    end
  end
  def list(e)
    pat = Regexp.compile(e)
    @db.select{|d| pat =~ d[0]}
  end
  def close
    CSV.open(@file, "wb") do |csv|
      @db.each {|x| csv << x}
    end
  end
end
