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
    if is_loggedin?
      @deck = Deck.create(params)
      @user = current_user
      @user.decks << @deck
      erb :"/decks/show"
    else
      redirect to "/users/login"
    end
  end

  get '/decks/:id/edit' do
    @deck = Deck.find(params[:id])
    erb :"/decks/edit"
  end

  patch '/decks/:id' do
    deck = Deck.find(params[:id])
    if is_loggedin? && (deck.user_id == current_user.id)
      if params[:name].strip != ""
        deck.update("name" => params[:name])
      end
      if params[:color].strip != ""
        deck.update("color" => params[:color])
      end
      if params[:size].strip != ""
        deck.update("size" => params[:size])
      end
      redirect to "/decks"
    else
      redirect to "/users/login"
    end
  end

  delete '/decks/:id' do
    deck = Deck.find(params[:id])
    if is_loggedin? && (deck.user_id == current_user.id)
      deck.delete
      redirect to "/decks"
    else
      redirect to "/users/login"
    end
  end

end
