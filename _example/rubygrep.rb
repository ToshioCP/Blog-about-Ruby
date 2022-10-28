r = Regexp.compile(ARGV[0])
File.readlines(ARGV[1]).each do |s|
  if r =~ s
    print s
  end
end
