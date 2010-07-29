require 'uri'
require 'mongo'

$mongo = begin
  if ENV['MONGOHQ_URL']
    conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
    conn.db(uri.path.gsub(/^\//, ''))
  else
    conn = Mongo::Connection.new
    conn.db("is_it_a_haiku")
  end
end