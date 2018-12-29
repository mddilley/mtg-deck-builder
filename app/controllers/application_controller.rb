class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "sinatraauthentication"
  end

  get '/' do
    "Hello world"
  end

end
