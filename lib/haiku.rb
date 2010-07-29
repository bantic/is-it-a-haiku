require File.expand_path(File.join(File.dirname(__FILE__), "haiku", "syllables"))

class Haiku
  HAIKU_FIRST_LINE_SYLLABLES = 5
  HAIKU_SECOND_LINE_SYLLABLES = 7
  HAIKU_THIRD_LINE_SYLLABLES = 5
  
  HAIKU_LINE_COUNT = 3
  
  def self.haiku?(text)
    text.gsub!(/\n+/,"\n")

    lines = text.split("\n")
    
    return false if lines.size != HAIKU_LINE_COUNT
    
    syllables = lines.collect {|line| Syllables.count(line)} 
    syllables == [HAIKU_FIRST_LINE_SYLLABLES, HAIKU_SECOND_LINE_SYLLABLES, HAIKU_THIRD_LINE_SYLLABLES]
  end
end