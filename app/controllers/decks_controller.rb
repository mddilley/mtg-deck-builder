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
    if Deck.find_by("name" => params[:name])
      flash[:duplicatedeck] = "A deck with that name already exists. Please choose another name."
      redirect to "/decks"
    end
    if is_loggedin? && params[:name].strip != "" && params[:size].strip != ""
      @deck = Deck.create(params)
      @user = current_user
      @user.decks << @deck
      erb :"/decks/show"
    elsif params[:name].strip == "" || params[:size].strip == ""
      flash[:incomplete] = "Invalid input. Please fill out all fields and submit to create a new deck."
      redirect to "/decks"
    else
      redirect to "/users/login"
    end
  end

  get '/decks/:id/edit' do
    @deck = Deck.find(params[:id])
    if is_loggedin? && (@deck.user_id == current_user.id)
      erb :"/decks/edit"
    else
      redirect to "/users/login"
    end
  end

  get '/decks/:id' do
    @deck = Deck.find(params[:id])
    if is_loggedin? && (@deck.user_id == current_user.id)
      erb :"/decks/show"
    else
      redirect to "/decks"
    end
  end

  patch '/decks/:id' do
    deck = Deck.find(params[:id])
    if is_loggedin? && (deck.user_id == current_user.id)
      deck.update("name" => params["deck"][:name]) if params["deck"][:name].strip != ""
      deck.update("color" => params["deck"][:color]) if params["deck"][:color] != ""
      deck.update("size" => params["deck"][:size]) if params["deck"][:size].strip != ""
      if params["card"][:name] != ""
        card = create_card(params["card"]["name"])
        deck.cards << card if card != nil && card_repl_limit(deck, card) && !deck_is_full?(deck)
        flash[:cardlimit] = "You may only add four copies of the same card to a single deck (except basic lands)." if !card_repl_limit(deck, card)
        flash[:deckfull] = "Your deck is full. Please increase deck size to add more cards." if deck_is_full?(deck)
      elsif params["card"][:id] != ""
        card = Card.find(params["card"][:id])
        deck.cards << card if card != nil && card_repl_limit(deck, card) && !deck_is_full?(deck)
        flash[:cardlimit] = "You may only add four copies of the same card to a single deck (except basic lands)." if !card_repl_limit(deck, card)
        flash[:deckfull] = "Your deck is full. Please increase deck size to add more cards." if deck_is_full?(deck)
      end
      redirect to "/decks/#{params[:id]}"
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
