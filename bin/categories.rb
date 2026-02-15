require 'yaml'

h_yaml = <<~HEREDOC
基本事項: basics
クラスとモジュール: classes-modules
Rails7: rails7
library: libraries
Procオブジェクト: proc
minitest: minitest
Ruby/GTK4: ruby/gtk4
並行処理: concurrency
Shoes: shoes
Glimmer: glimmer
Documentation: documentation
Rubygems: rubygems
HEREDOC

h_hash = YAML.load(h_yaml)
h_array = h_hash.map { |k, v| ["category: #{k}", "category: #{v}" ] }

Dir.children("_posts").each do |filename|
    File.open("_posts/#{filename}") do |file|
        content = file.read
        h_array.each do |from, to|
          content = content.gsub(from, to)
        end
        File.write("_posts/#{filename}", content)
    end
end

