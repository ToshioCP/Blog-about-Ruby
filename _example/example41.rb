# p $stdin.external_encoding
# p $stdout.external_encoding
# p $stderr.external_encoding
# p $stdin.internal_encoding
# p $stdout.internal_encoding
# p $stderr.internal_encoding
# stream = File.open("example41.rb")
# p stream.external_encoding
# p stream.internal_encoding
# stream.close

# s = "あ"
# p s.encoding #=>#<Encoding:UTF-8>
# t = s.encode(Encoding::EUC_JP)
# p t.encoding #=>#<Encoding:EUC-JP>
# p s.force_encoding(Encoding::ASCII_8BIT)
# p t.force_encoding(Encoding::ASCII_8BIT)
# p s == t

# f = File.open("gr_euc.txt", "r")
# f.set_encoding("EUC-JP", "UTF-8")
# print f.read
# f.close

s = "あいうえお" # UTF-8
f = File.open("gr.txt", "w")
f.write(s) # UTF-8で出力
f.close

f = File.open("gr_euc.txt", "w")
f.set_encoding("EUC-JP")
f.write(s) # EUC-JPで出力
f.close

f = File.open("gr_sjis.txt", "w")
f.set_encoding("SJIS","UTF-8")
f.write(s) # Shift-JISで出力
f.close
