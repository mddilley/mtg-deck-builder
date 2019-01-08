class UsersController < ApplicationController

  get '/users/signup' do
    if !is_loggedin?
      erb :"/users/signup"
    else
      redirect to "/decks"
    end
  end

  post '/users/signup' do
    if !is_loggedin? && !User.find_by("username" => params["username"])
      if params["username"] != "" && params["password"] != "" && params["email"] != ""
        @user = User.create(params)
        login(@user.id)
        erb :"/decks/index"
      else
        flash[:invalidsignup] = "Invalid input. Please fill out all fields and submit to sign up."
        redirect to "/users/signup"
      end
    elsif User.find_by("username" => params["username"])
      flash[:invalidusername] = "This username is not available. Please choose another and submit to sign up."
      redirect to "/users/signup"
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
      !@user ? flash[:invaliduser] = "Invalid username. Please enter your correct username to login." : flash[:invalidpw] = "Invalid password. Please enter your correct password to login."
      redirect to "/users/login"
    end
  end

  get '/users/logout' do
    logout
    redirect to "/"
  end

end
