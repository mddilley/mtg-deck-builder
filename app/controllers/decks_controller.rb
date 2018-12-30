class DecksController < ApplicationController

  get '/decks/new' do
    if is_loggedin?
      erb :"/decks/new"
    else
      redirect to "/users/login"
    end
  end

  post '/decks' do
    @deck = Deck.create(params)
    if is_loggedin?
      erb :"/decks/show"
    else
      redirect to "/users/login"
    end
  end

end
