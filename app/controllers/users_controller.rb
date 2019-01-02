class UsersController < ApplicationController

  get '/users/signup' do
    if !is_loggedin?
      erb :"/users/signup"
    else
      redirect to :"/decks"
    end
  end

  post '/users/signup' do
    if !is_loggedin? && !User.find_by("username" => params["username"])
      @user = User.create(params)
      login(@user.id)
      erb :"/decks/index"
    else
      redirect to "/"
    end
  end

  get '/users/login' do
    if !is_loggedin?
      erb :"/users/login"
    else
      redirect to "/decks"
    end
  end

  post '/users/login' do
    @user = User.find_by(:username => params["username"])
    if !!@user && !!@user.authenticate(params[:password])
      login(@user.id)
      erb :"/decks/index"
    else
      redirect to :"/users/login"
    end
  end

  get '/users/logout' do
    logout
    redirect to "/"
  end

end
