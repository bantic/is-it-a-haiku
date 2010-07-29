class Dictionary
  attr_accessor :collection
  
  def self.create(dict_file, lang="en")
    collection = $mongo.collection("pronunciations")
    
    IO.foreach( dict_file ).each do |line|
      next if line !~ /^[A-Z]/
      line.chomp!
      (word, *phonemes) = line.split(/  ?/)
      next if word =~ /\(\d\) ?$/ # ignore alternative pronunciations
      
      syllables = phonemes.grep(/^[AEIUO]/).length
      
      puts "#{word} #{syllables} (#{lang})"
      collection.save({:word => word, :syllables => syllables, :lang => lang})
    end
    collection.create_index([['word',1],['lang',1]])
  end
  
  def initialize(lang="en")
    @lang = lang
    @collection = $mongo.collection("pronunciations")
    unless @collection.find_one
      raise "Dictionary is missing or empty. Use rake dictionary:create"
    end
  end
  
  def fetch(word)
    if result = @collection.find_one({:word => word, :lang => @lang})
      result['syllables']
    else
      0
    end
  end
end
