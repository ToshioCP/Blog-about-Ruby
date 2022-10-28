class User
  include Enumerable

  @@count = -1
  @@accessors = ["name", "email", "birth_date"]
  attr_reader :id
  attr_accessor *@@accessors
  def initialize
    @id = @@count += 1
  end
  def each
    if block_given?
      yield("id", @id)
      @@accessors.each do |a|
        yield(a, eval("@#{a}"))
      end
    else
      self.to_enum
    end
  end
  def to_h
    map {|k, v| [k.to_sym, v]}.to_h
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

p user.to_h
p user1.each

toshio = {}
toshio[:id] = 0
toshio[:name] = "Toshio Sekiya"
toshio[:email] = "abcdefg@example.com"
toshio[:birth_date] = "YYYY/MM/DD"

p toshio #=> {:id=>0, :name=>"Toshio Sekiya", :email=>"abcdefg@example.com", :birth_date=>"YYYY/MM/DD"}
