#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby

require_relative 'lib_wordbook.rb'

def usage
  $stderr.print "Usage: wordbook [file]\n"
  exit
end

if ARGV.size > 1 || ARGV[0] =~ /--help|-h/
  usage
end
if ARGV.size == 1
  wb = WordBook.new(ARGV[0])
else
  wb = WordBook.new
end
wb.run
