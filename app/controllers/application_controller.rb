class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "35cbcfd4aa24ac8ed4cfc49f7baeb022"
  end

  get '/' do
    erb :index
  end

end
