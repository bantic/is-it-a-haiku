class IsItAHaikuApp < Sinatra::Application
  require "lib/haiku"
  require "haml"
  require "sass"
  
  @@haikus = $mongo.collection("haikus")
  
  configure :production, :staging do 
    require "exceptional"
    require "lib/exceptional"
    exceptional_api_key = ENV['EXCEPTIONAL_API_KEY'] 
    ::Exceptional.configure(exceptional_api_key) 
    ::Exceptional::Config.enabled = true 
    ::Exceptional.logger.info "Enabling Exceptional for Sinatra" 
  end
  
  get '/' do
    @random_haiku = random_haiku
    haml :index
  end
  
  post '/' do
    text          = params[:haiku]
    is_it_a_haiku = Haiku.haiku?(text)
    id            = @@haikus.save(:text => text, :haiku => is_it_a_haiku, :timestamp => Time.now)
    redirect "/haikus/#{id}"
  end
  
  get '/haikus/:id' do
    object_id = begin
      BSON::ObjectID.from_string(params[:id])
    rescue BSON::InvalidObjectID
      pass
    end
    
    if @haiku = @@haikus.find_one(object_id)
      haml :haiku
    else
      pass
    end
  end

  get "/raise" do
     raise "Uh-oh!"
  end
  
  get '/haikus' do
    haiku = random_haiku
    puts haiku.inspect
    if haiku['_id']
      redirect "/haikus/#{random_haiku['_id']}" 
    else
      redirect "/"
    end
  end
  
  get '/stylesheet.css' do
    content_type 'text/css', :charset => 'utf-8'
    sass :stylesheet
  end
  
  get "/broken" do
    @haikus = @@haikus.find(:haiku => false, :dismissed => {"$ne" => true}).limit(10)
    haml :broken
  end
  
  post "/dismiss/:id" do
    object_id = begin
      BSON::ObjectID.from_string(params[:id])
    rescue BSON::InvalidObjectID
      pass
    end
    
    if @haiku = @@haikus.find_one(object_id)
      @haiku[:dismissed] = true
      @@haikus.save(@haiku)
    end
    ""
  end
  
  helpers do
    def random_haiku
      random_haiku = begin
        count = @@haikus.find(:haiku => true).count()
        if count > 0
          @@haikus.find(:haiku => true).limit(-1).skip(rand(count)).first()
        else
          {'text' => "This is the first line\nand this is the second line\nand this is the third"}
        end
      end
    end
  end
end
