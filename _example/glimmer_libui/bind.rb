require 'glimmer-dsl-libui'

include Glimmer

class A
  attr_accessor :data
  def initialize
    @data = ""
  end
end

window('バインディング', 800, 100) {
  margined true
  
  a = A.new
  vertical_box {
    entry {
      text <=> [a, :data]
    }
    label {
      text <= [a, :data]
    }
  }
}.show
