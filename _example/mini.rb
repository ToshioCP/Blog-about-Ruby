@sym_table = []

def lookup(k)
  @sym_table.each do |a|
    if a[0] == k
      return a[1]
    end
  end
  nil
end

def install (k, v)
  @sym_table.each do |a|
    if a[0] == k
      a[1] = v
      return
    end
  end
  @sym_table << [k, v]
end

File.readlines(ARGV[0]).each_with_index do |s, i|
  # print @sym_table, "\n"
  if /^print +(\w+)$/ =~ s
    k = $1
    v = lookup(k)
    if v
      print v, "\n"
    else
      print "Error #{k} is not defined.\n"
      exit
    end
  elsif /(\w+) *= *(\d+)$/ =~ s
    k = $1
    v = $2
    install(k, v)
  elsif /^ *$/ =~ s
    # ignore
  else 
    print "Syntax error in #{i+1}\n"
    exit
  end
end
