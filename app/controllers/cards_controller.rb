class CardsController < ApplicationController

  get '/cards/new' do
    redirect_to_login?
    erb :"/cards/new"
  end

  get '/cards' do
    redirect_to_login?
    @user = current_user
    erb :"/cards/index"
  end

  get '/cards/:id' do
    redirect_to_login?
    @card = Card.find(params[:id])
    erb :"/cards/show"
  end

  delete '/cards/:id/:deck_id' do
    redirect_to_login?
    carddeck = CardDeck.find_by("card_id" => params[:id], "deck_id" => params[:deck_id])
    deck = Deck.find(params[:deck_id])
    if deck_owner?(deck)
      carddeck.delete
      redirect to "/decks/#{deck.id}"
    end
  end

  delete '/cards/:id' do
    redirect_to_login?
    card = Card.find(params[:id])
    card.delete if current_user.cards.include?(card)
    redirect to "/cards"
  end

end
