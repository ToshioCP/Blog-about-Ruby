[10,20,30].each do |x|
  print x, "\n"
end

x = 10
while x <= 30
  print x, "\n" # iを引数にブロックを実行
  x += 10
end

x=10; print x, "\n" # 10を引数にブロックを実行
x=20; print x, "\n" # 20を引数にブロックを実行
x=30; print x, "\n" # 30を引数にブロックを実行

# リファクターしたUserクラスはuser.rbに
class User
  @@count = -1
  attr_reader :id
  attr_accessor :name, :email, :birth_date
  def initialize
    @id = @@count += 1
  end
  def each
    yield("id", @id)
    yield("name", @name)
    yield("email", @email)
    yield("birth_date", @birth_date)
  end
end

user = User.new
user.name = "Toshio Sekiya"
user.email = "abcdefg@example.com"
user.birth_date = "YYYY/MM/DD"
user.each{|k,v| print "#{k}: #{v}\n"}
user1 = User.new
user1.name = "Jeaou Robinson"
user1.email = "xyz@example.co.uk"
user1.birth_date = "yyyy/mm/dd"
user1.each{|k,v| print "#{k}: #{v}\n"}

# eachからmapを作る例
# class User
#   def map
#     a = []
#     each do |k, v|
#       a << yield(k, v)
#     end
#     a
#   end
# end

# p user.map{|k,v| [k,v]}.to_h

p user.to_enum.map{|k,v| [k,v]}.to_h
