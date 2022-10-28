require_relative 'input.rb'
require_relative 'db.rb'

class WordBook
  def initialize(*file)
    @input = Input.new
    if file[0]
      @db = DB.new(file[0])
    else
      @db = DB.new
    end
  end

  def run
    while true
      a = @input.input #=> an array like [command, English, Japanese]
      return unless a
      case a[0]
      when 'a'
        @db.append(a[1], a[2])
      when 'd'
        @db.delete(a[1])
      when 'c'
        @db.change(a[1], a[2])
      when 'p'
        d = @db.list(a[1]).to_a
        d.each do |e,j|
          print "#{e} - #{j}\n"
        end
      when 'q'
        @db.close # save data
        break
      end
    end
  end
end
