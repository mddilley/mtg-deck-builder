class DecksController < ApplicationController

  get '/decks/new' do
    if is_loggedin?
      erb :"/decks/new"
    else
      redirect to "/users/login"
    end
  end

  get '/decks' do
    @user = current_user
    erb :"/decks/show"
  end

  post '/decks' do
    @deck = Deck.create(params)
    @user = current_user
    @user.decks << @deck
    if is_loggedin?
      erb :"/decks/show"
    else
      redirect to "/users/login"
    end
  end

end
