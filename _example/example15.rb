module Abc
  def abc
    print "abcdefg\n"
  end
end

include Abc
abc

class Xyz
  include Abc
  def xyz
    abc
  end
end

x = Xyz.new
x.abc
x.xyz

class Enoden
  include Comparable

  attr_reader :station_number, :name
  def initialize station_number, name
    @station_number = station_number
    @name = name
  end
  def <=>(other)
    self.station_number.slice(2..3).to_i <=> other.station_number.slice(2..3).to_i
  end
  def to_s
    "#{@station_number}: #{@name}"
  end
end

station_number = (1..15).map{|i| sprintf("EN%02d", i)}
name = "藤沢 石上 柳小路 鵠沼 湘南海岸公園 江ノ島 腰越 鎌倉高校前 七里ヶ浜 稲村ヶ崎 極楽寺 長谷 由比ヶ浜 和田塚 鎌倉".split(/ /)

enoshima = Enoden.new(station_number[5], name[5])
inamuragasaki = Enoden.new(station_number[9], name[9])
kamakura = Enoden.new(station_number[14], name[14])

print enoshima, "\n"
print inamuragasaki, "\n"
print enoshima < inamuragasaki, "\n"
print [kamakura, enoshima, inamuragasaki].sort.map{|a| a.to_s}, "\n"