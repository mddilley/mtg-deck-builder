class CardsController < ApplicationController

  get '/cards/new' do
    if is_loggedin?
      erb :"/cards/new"
    else
      redirect to "/users/login"
    end
  end

  get '/cards' do
    @user = current_user
    erb :"/cards/index"
  end

  post '/cards' do
    if is_loggedin?
      @card = Card.create(params)
      @deck = current_user
      @user.cards << @deck
      erb :"/cards/show"
    else
      redirect to "/users/login"
    end
  end
  #
  # get '/decks/:id/edit' do
  #   @deck = Deck.find(params[:id])
  #   erb :"/decks/edit"
  # end
  #
  # get '/decks/:id' do
  #   @deck = Deck.find(params[:id])
  #   erb :"/decks/show"
  # end
  #
  # patch '/decks/:id' do
  #   deck = Deck.find(params[:id])
  #   if is_loggedin? && (deck.user_id == current_user.id)
  #     if params[:name].strip != ""
  #       deck.update("name" => params[:name])
  #     end
  #     if params[:color].strip != ""
  #       deck.update("color" => params[:color])
  #     end
  #     if params[:size].strip != ""
  #       deck.update("size" => params[:size])
  #     end
  #     redirect to "/decks"
  #   else
  #     redirect to "/users/login"
  #   end
  # end
  #
  # delete '/decks/:id' do
  #   deck = Deck.find(params[:id])
  #   if is_loggedin? && (deck.user_id == current_user.id)
  #     deck.delete
  #     redirect to "/decks"
  #   else
  #     redirect to "/users/login"
  #   end
  # end

end
