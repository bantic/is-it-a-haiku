# You'll need to require these if you
# want to develop while running with ruby.
# The config/rackup.ru requires these as well
# for its own reasons.
#
# $ ruby heroku-sinatra-app.rb
#
class IsItAHaikuApp < Sinatra::Application
  require "lib/haiku"
  require "haml"
  require "sass"
  
  @@haikus = $mongo.collection("haikus")
  
  configure :production do
    # Configure stuff here you'll want to
    # only be run at Heroku at boot

    # TIP:  You can get you database information
    #       from ENV['DATABASE_URI'] (see /env route below)
  end

  # Quick test
  get '/' do
    haml :index
  end
  
  post '/' do
    text = params[:haiku]
    is_it_a_haiku = Haiku.haiku?(text)
    id = @@haikus.save(:text => text, :haiku => is_it_a_haiku, :timestamp => Time.now)
    redirect "/haikus/#{id}"
  end
  
  get '/haikus/:id' do
    if @haiku = @@haikus.find_one(BSON::ObjectID.from_string(params[:id]))
      haml :haiku
    end
  end
  
  get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
  end
end