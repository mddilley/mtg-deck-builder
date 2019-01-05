class CardsController < ApplicationController

  get '/cards/new' do
    if is_loggedin?
      erb :"/cards/new"
    else
      redirect to "/users/login"
    end
  end

  get '/cards' do
    if is_loggedin?
      @user = current_user
      erb :"/cards/index"
    else
      redirect to "/users/login"
    end
  end

  get '/cards/:id' do
    if is_loggedin?
      @card = Card.find(params[:id])
      erb :"/cards/show"
    else
      redirect to "/users/login"
    end
  end

  delete '/cards/:id/:deck_id' do
    carddeck = CardDeck.find_by("card_id" => params[:id], "deck_id" => params[:deck_id])
    deck = Deck.find(params[:deck_id])
    if is_loggedin? && (deck.user_id == current_user.id)
      carddeck.delete
      redirect to "/decks"
    else
      redirect to "/users/login"
    end
  end

  delete '/cards/:id' do
    card = Card.find(params[:id])
    if is_loggedin? && (current_user.cards.include?(card))
      card.delete
      redirect to "/cards"
    else
      redirect to "/users/login"
    end
  end

end
