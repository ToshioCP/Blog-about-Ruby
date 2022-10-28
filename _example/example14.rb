d = <<EOS
北海道	5224614
青森県	1237984
岩手県	1210534
宮城県	2301996
秋田県	959502
山形県	1068027
福島県	1833152
茨城県	2867009
栃木県	1933146
群馬県	1939110
埼玉県	7344765
千葉県	6284480
東京都	14047594
神奈川県	9237337
新潟県	2201272
富山県	1034814
石川県	1132526
福井県	766863
山梨県	809974
長野県	2048011
岐阜県	1978742
静岡県	3633202
愛知県	7542415
三重県	1770254
滋賀県	1413610
京都府	2578087
大阪府	8837685
兵庫県	5465002
奈良県	1324473
和歌山県	922584
鳥取県	553407
島根県	671126
岡山県	1888432
広島県	2799702
山口県	1342059
徳島県	719559
香川県	950244
愛媛県	1334841
高知県	691527
福岡県	5135214
佐賀県	811442
長崎県	1312317
熊本県	1738301
大分県	1123852
宮崎県	1069576
鹿児島県	1588256
沖縄県	1467480
EOS

d = d.split(/\n/)\
     .map{|s| s.split(/\t/)}\
     .map{|a| [a[0].to_sym, a[1].to_i]}\
     .to_h

class Stat < Hash
  def initialize h={}
    super()
    update(h)
  end
  def find_by_value(v)
    Stat.new(select{|key, value| value == v})
  end
  def max
    m = map{|k,v| v}.max
    find_by_value(m)
  end
  def min
    m = map{|k,v| v}.min
    find_by_value(m)
  end
  def average
    (map{|k,v| v}.sum.to_f/size).round(1)
  end
  def sort
    Stat.new(super{|a,b| a[1]<=>b[1]}.to_h)
  end
  def reverse
    Stat.new(to_a.reverse.to_h)
  end
end

s = Stat.new(d)
p s.find_by_value(7344765)
p s.find_by_value(0)
p s.max
p s.min
p s.average
p s.sort
p s.sort.reverse
