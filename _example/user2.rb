class User
  include Enumerable

  @@count = -1
  attr_reader :id
  attr_accessor :name, :email, :birth_date
  def initialize
    @id = @@count += 1
  end
  def each
    if block_given?
      instance_variables.each do |iv|
        yield(iv.to_s.slice(1..-1), eval(iv.to_s))
      end
    else
      self.to_enum
    end
  end
  def to_h
    map {|k, v| [k.to_sym, v]}.to_h
  end
  def show
    each do |k, v|
      print "#{k}: #{v}\n"
    end
  end
end

user = User.new
user.name = "Toshio Sekiya"
user.email = "abcdefg@example.com"
user.birth_date = "YYYY/MM/DD"
user1 = User.new
user1.name = "Jeaou Robinson"
user1.email = "xyz@example.co.uk"
user1.birth_date = "yyyy/mm/dd"

User.attr_accessor(:location)
user.location = "Japan"
user.show
user1.show
