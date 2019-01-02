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
        url = "https://api.scryfall.com/cards/named?fuzzy=#{card_name_to_search_name(params["card"]["name"])}"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        c = JSON.parse(response)
        card = Card.create("name" => c["name"])
        card.mana_cost = c["mana_cost"]
        card.card_type = c["type_line"]
        card.card_text = c["oracle_text"]
        card.colors = c["colors"]
        card.expansion = c["set_name"]
        card.rarity = c["rarity"]
        c["flavor_text"] ? card.flavor_text = c["flavor_text"] : card.flavor_text = "n/a"
        card.img_url = c["image_uris"]["normal"]
        c["power"] ? card.power = c["power"] : card.power = "n/a"
        c["toughness"] ? card.toughness = c["toughness"] : card.toughness = "n/a"
        binding.pry
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
