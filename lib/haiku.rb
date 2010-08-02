require File.expand_path(File.join(File.dirname(__FILE__), "haiku", "dictionary"))
require File.expand_path(File.join(File.dirname(__FILE__), "haiku", "syllables"))
require File.expand_path(File.join(File.dirname(__FILE__), "..", "config", "initializers", "mongo"))

class Haiku
  HAIKU_FIRST_LINE_SYLLABLES = 5
  HAIKU_SECOND_LINE_SYLLABLES = 7
  HAIKU_THIRD_LINE_SYLLABLES = 5
  
  HAIKU_LINE_COUNT = 3
  
  class << self
    def haiku?(text)
      text = clean_text(text)

      lines = text.split("\n")
    
      return false if lines.size != HAIKU_LINE_COUNT
    
      syllables = lines.collect {|line| Syllables.count(line)} 
      syllables == [HAIKU_FIRST_LINE_SYLLABLES, HAIKU_SECOND_LINE_SYLLABLES, HAIKU_THIRD_LINE_SYLLABLES]
    end
  
    def clean_text(text)
      return "" if text.nil?
      
      text = text.strip
      text = text.gsub(/\n+/,"\n")
    end
  end
end