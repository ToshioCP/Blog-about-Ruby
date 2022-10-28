require 'webrick'
srv = WEBrick::HTTPServer.new({ :DocumentRoot => './',
                                :BindAddress => '127.0.0.1',
                                :Port => 20080})
srv.mount('/view.cgi', WEBrick::HTTPServlet::CGIHandler, 'view.rb')
srv.mount('/foo.html', WEBrick::HTTPServlet::FileHandler, 'hoge.html')
trap("INT"){ srv.shutdown }
srv.start