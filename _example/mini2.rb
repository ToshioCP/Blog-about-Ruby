HSIZE = 5000
@h_table = []

def mini_hash(s)
  s.hash % HSIZE
end

def lookup(k)
  node = @h_table[mini_hash(k)]
  while node
    if node[1] == k
      return node[2]
    end
    node = node[0]
  end
  nil
end

def install (k, v)
  node = @h_table[mini_hash(k)]
  if node == nil
    @h_table[mini_hash(k)] = [nil, k, v]
    return
  elsif node[1] == k
    node[2] = v
    return
  else
    while node[0]
      if node[0][1] == k
        node[0][2] = v
        return
      end
      node = node[0]
    end
    node[0] = [nil, k, v]
  end
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
