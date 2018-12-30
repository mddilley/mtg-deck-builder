class UsersController < ApplicationController

  get '/users/signup' do
    if is_loggedin?
      erb :"/users/signup"
    else
      redirect to "/decks/show"
    end
  end

  post '/users/signup' do
    if !is_loggedin?
      @user = User.create(params)
      login(@user.id)
      erb :"/decks/show"
    else
      redirect to "/"
    end
  end

  get '/users/login' do
    if !is_loggedin?
      erb :"/users/login"
    else
      erb :"/decks/show"
    end
  end

  post '/users/login' do
    @user = User.find_by(:username => params["username"])
    if !is_loggedin?
      login(params)
      erb :"/decks/show"
    else
      erb :"/decks/show"
    end
  end

  get '/users/logout' do
    logout
    redirect to "/users/login"
  end

end
