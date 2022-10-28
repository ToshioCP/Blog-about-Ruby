require 'minitest/autorun'
require 'fileutils'

# The test will be done under 'temp_test_main_wordbook' directory
class TestMainWorkbook < Minitest::Test
  include FileUtils
  def setup
    @tempd = 'temp_test_main_wordbook' 
    mkdir_p @tempd
    cp 'wordbook.rb', "#{@tempd}/wordbook.rb"
    # Put a stub of "lib_wordbook.rb" under the tepmorary directory.
    # It just prints the argument.
    File.write("#{@tempd}/lib_wordbook.rb", <<~'EOS')
    class WordBook
      def initialize(file="db.csv")
        @file = file
      end
      def run
        print @file, "\n"
      end
    end
    EOS
    cd @tempd
  end
  def teardown
    cd '..'
    remove_entry_secure @tempd
  end
  def test_main_wordbook
    assert_equal("Usage: wordbook [file]\n", `ruby wordbook.rb --help 2>&1`)
    assert_equal("Usage: wordbook [file]\n", `ruby wordbook.rb -h 2>&1`)
    assert_equal("Usage: wordbook [file]\n", `ruby wordbook.rb a.csv b.csv 2>&1`)
    assert_equal("db.csv\n", `ruby wordbook.rb`)
    assert_equal("abc.csv\n", `ruby wordbook.rb abc.csv`)
  end
end
