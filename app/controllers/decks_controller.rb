class DecksController < ApplicationController

  get '/decks/new' do
    redirect_to_login?
    erb :"/decks/new"
  end

  get '/decks' do
    redirect_to_login?
    @user = current_user
    erb :"/decks/index"
  end

  post '/decks' do
    redirect_to_login?
    if Deck.find_by("name" => params[:name])
      flash[:duplicatedeck] = "A deck with that name already exists. Please choose another name."
      redirect to "/decks"
    end
    if Deck.valid_params?("&&", params)
      @user = current_user
      @deck = @user.decks.create(params)
      erb :"/decks/show"
    elsif Deck.valid_params?("||", params)
      flash[:incomplete] = "Invalid input. Please fill out all fields and submit to create a new deck."
      redirect to "/decks"
    else
      redirect to "/users/login"
    end
  end

  get '/decks/:id/edit' do
    redirect_to_login?
    @deck = Deck.find(params[:id])
    if @deck.user_id == current_user.id
      erb :"/decks/edit"
    else
      redirect to "/decks"
    end
  end

  get '/decks/:id' do
    redirect_to_login?
    @deck = Deck.find(params[:id])
    if @deck.user_id == current_user.id
      erb :"/decks/show"
    else
      redirect to "/decks"
    end
  end

  patch '/decks/:id' do
    redirect_to_login?
    deck = Deck.find(params[:id])
    if deck.user_id == current_user.id
      Deck.update_deck(deck, params)
      card = Deck.add_card_to_deck(deck, params)
      flash[:cardlimit] = "You may only add four copies of the same card to a single deck (except basic lands)." if !Deck.card_repl_limit(deck, card)
      flash[:deckfull] = "Your deck is full. Please increase deck size to add more cards." if Deck.deck_is_full?(deck)
      redirect to "/decks/#{deck.id}"
    else
      redirect to "/users/login"
    end
  end

  delete '/decks/:id' do
    redirect_to_login?
    deck = Deck.find(params[:id])
    if deck.user_id == current_user.id
      deck.delete
      redirect to "/decks"
    else
      redirect to "/users/login"
    end
  end

end
