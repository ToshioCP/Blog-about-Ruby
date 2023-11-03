#!/usr/bin/env ruby

require 'calc'

if ARGV.size != 1
  print "Usage: simple_calc expression\n"
  print "Example: simple_calc 1+2*3\n"
else
  c = Calc.new
  print "#{c.run(ARGV[0])}\n"
end
