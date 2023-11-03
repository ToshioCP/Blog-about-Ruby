require 'fileutils'
include FileUtils

cp __dir__ + "/simple_calc.rb", "#{Dir.home}/.local/bin/simple_calc"
chmod 0755, "#{Dir.home}/.local/bin/simple_calc"
