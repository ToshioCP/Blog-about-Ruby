#!/bin/sh
exec ruby -x "$0" "$@"
#!ruby

print ARGV.join(' '), "\n"
