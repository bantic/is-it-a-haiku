class Dictionary
  attr_accessor :collection
  
  def self.collection
    @@collection ||= $mongo.collection("pronunciations")
  end
  
  def self.create(dict_file, lang="en")
    IO.foreach( dict_file ).each do |line|
      next if line !~ /^[A-Z]/
      line.chomp!
      (word, *phonemes) = line.split(/  ?/)
      next if word =~ /\(\d\) ?$/ # ignore alternative pronunciations
      
      syllables = phonemes.grep(/^[AEIUO]/).length
      
      puts "#{word} #{syllables} (#{lang})"
      update(word, syllables, lang)
    end
    collection.create_index([['word',1],['lang',1]])
  end
  
  def self.update(word, syllables, lang="en")
    puts "#{word} #{syllables} (#{lang})"
    
    collection.save({:word => word.upcase, :syllables => syllables.to_i, :lang => lang})
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
      nil
    end
  end
end
