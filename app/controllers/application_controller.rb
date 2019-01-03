class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => '35cbcfd4aa24ac8ed4cfc49f7baeb022'
  end

  get '/' do
    if is_loggedin?
      redirect to "/decks"
    else
      erb :index
    end
  end

  helpers do

    # User helper methods

    def is_loggedin?
      !!session[:id]
    end

    def login(id)
      session[:id] = id
    end

    def logout
      session.clear
    end

    def current_user
      User.find(session[:id])
    end

    # Card helper methods

    def card_name_to_search_name(name)
      name.downcase.split.join("+")
    end

    def create_card(card_name)
      # binding.pry
      url = "https://api.scryfall.com/cards/named?fuzzy=#{card_name_to_search_name(card_name)}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      card = JSON.parse(response)
      if card["status"] == 404
        puts card["details"] #Store details in card var to flash?
        card = nil
      else
        add_card_attr(card)
      end
    end

    def add_card_attr(c)
      Card.find_or_create_by("name" => c["name"]).tap { |card|
        card.mana_cost = c["mana_cost"]
        card.card_type = c["type_line"]
        card.card_text = c["oracle_text"]
        card.colors = c["colors"]
        card.expansion = c["set_name"]
        card.rarity = c["rarity"]
        c["flavor_text"] ? card.flavor_text = c["flavor_text"] : card.flavor_text = "n/a"
        card.img_url = c["image_uris"]["border_crop"]
        c["power"] ? card.power = c["power"] : card.power = "n/a"
        c["toughness"] ? card.toughness = c["toughness"] : card.toughness = "n/a"
      }
    end

    # Deck helper methods

    def checked(color)
      "checked" if @deck.color.include?(color)
    end

    def card_repl_limit(deck, card)
      deck.cards.select {|c| c.name == card.name}.size < 4
    end

    def deck_is_full?(deck)
      deck.cards.size < deck.size.to_i
    end

  end

end
