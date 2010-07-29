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

  configure :production do
    # Configure stuff here you'll want to
    # only be run at Heroku at boot

    # TIP:  You can get you database information
    #       from ENV['DATABASE_URI'] (see /env route below)
  end

  # Quick test
  get '/' do
    # haml :index
    val = require('dbm')
    "val: #{val}. dbm: #{DBM}"
  end
  
  post '/' do
    "The text is a haiku? #{Haiku.haiku?(params[:haiku]) ? "YES" : "NO"}"
  end

  # Test at <appname>.heroku.com

  # You can see all your app specific information this way.
  # IMPORTANT! This is a very bad thing to do for a production
  # application with sensitive information

  # get '/env' do
  #   ENV.inspect
  # end
end