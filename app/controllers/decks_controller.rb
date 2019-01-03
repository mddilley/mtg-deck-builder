class DecksController < ApplicationController

  get '/decks/new' do
    if is_loggedin?
      erb :"/decks/new"
    else
      redirect to "/users/login"
    end
  end

  get '/decks' do
    if is_loggedin?
      @user = current_user
      erb :"/decks/index"
    else
      redirect to "/users/login"
    end
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
    if is_loggedin?
      @deck = Deck.find(params[:id])
      erb :"/decks/edit"
    else
      redirect to "/users/login"
    end
  end

  get '/decks/:id' do
    if is_loggedin?
      @deck = Deck.find(params[:id])
      erb :"/decks/show"
    else
      redirect to "/users/login"
    end
  end

  patch '/decks/:id' do
    deck = Deck.find(params[:id])
    if is_loggedin? && (deck.user_id == current_user.id)
      if params["deck"][:name].strip != ""
        deck.update("name" => params["deck"][:name])
      end
      if params["deck"][:color].strip != ""
        deck.update("color" => params["deck"][:color])
      end
      if params["deck"][:size].strip != ""
        deck.update("size" => params["deck"][:size])
      end
      if params["card"][:name] != ""
        card = get_card_attr(params["card"]["name"])
        deck.cards << card
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
