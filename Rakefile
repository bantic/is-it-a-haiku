namespace :dictionary do
  task :create do
    require File.dirname(__FILE__) + "/lib/haiku"
    Dictionary.create(File.dirname(__FILE__) + "/db/cmudict.0.7a.txt", lang="en")
  end
  
  task :update_custom do
    require File.dirname(__FILE__) + "/lib/haiku"
    IO.foreach( File.dirname(__FILE__) + "/db/custom_pronunciations.txt" ).each do |line|
      word, syllables = line.split(" ")
      Dictionary.update(word, syllables)
    end
  end
end