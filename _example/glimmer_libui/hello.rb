require 'glimmer-dsl-libui'

include Glimmer

w = window('hello') {
  label('Hello world')
}

w.show
