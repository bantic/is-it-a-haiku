namespace :dictionary do
  task :create do
    require File.dirname(__FILE__) + "/lib/haiku"
    Dictionary.create(File.dirname(__FILE__) + "/db/cmudict.0.7a.txt", lang="en")
  end
end