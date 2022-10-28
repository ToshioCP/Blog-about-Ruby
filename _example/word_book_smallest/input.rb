require 'readline'

class Input
  def input
    while true
      buf = Readline.readline("wb > ", false)
      if buf =~ /^[ac] +[a-zA-Z]+ +\S+$|^d +[a-zA-Z]+$|^p +\S+$|^q$/
        return buf.split(' ')
      else
        $stderr.print "(a|c) 英単語 日本語訳\nd 英単語\np 正規表現\nq\n"
      end
    end
  end
end
