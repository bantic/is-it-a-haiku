require 'dbm'

class Syllables
  class LookUpError < IndexError; end
  
  class << self
    def count(text)
      words_from_text(text).inject(0) {|sum, word| sum += count_word(word) }
    end
    
    def words_from_text(text)
      words = []

      text.gsub!("’","'")

      text.scan(/\b([a-z][a-z\-']*)\b/i).each do |match|
        words.push match[0]
      end
      words
    end
    
    def count_word(word)
      word.upcase!
      begin
        pronounce = dictionary.fetch(word)
      rescue IndexError
        if word =~ /'/
          word = word.delete "'"
          retry
        end
        raise LookUpError, "word #{word} not in dictionary"
      end
      
      pronounce.split(/-/).grep(/^[AEIUO]/).length
    end
    
    def dictionary
      @@dbm ||= DBM.new( File.join(File.dirname(__FILE__), "..", "..", "db", "dict") )
    end
  end
end