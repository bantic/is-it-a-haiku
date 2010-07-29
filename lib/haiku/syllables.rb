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

      unless syllables = dictionary.fetch(word)
        if word =~ /'/
          word = word.delete "'"
          syllables = count_word(word)
        end
      end
      
      raise LookUpError unless syllables
      syllables
    end
    
    def dictionary
      @@db ||= Dictionary.new
    end
  end
end