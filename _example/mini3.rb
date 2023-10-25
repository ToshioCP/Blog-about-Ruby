@sym_table = {}

File.readlines(ARGV[0]).each_with_index do |s, i|
  # print @sym_table, "\n"
  if /^print +(\w+)$/ =~ s
    k = $1
    v = @sym_table[k]
    if v
      print v, "\n"
    else
      print "Error #{k} is not defined.\n"
      exit
    end
  elsif /(\w+) *= *(\d+)$/ =~ s
    k = $1
    v = $2
    @sym_table[k] = v
  elsif /^ *$/ =~ s
    # ignore
  else 
    print "Syntax error in #{i+1}\n"
    exit
  end
end
