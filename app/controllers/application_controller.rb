class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => '35cbcfd4aa24ac8ed4cfc49f7baeb022'
    # enable :sessions
    register Sinatra::Flash
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
      url = "https://api.scryfall.com/cards/named?fuzzy=#{card_name_to_search_name(card_name)}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      card = JSON.parse(response)
      if card["status"] == 404
        flash[:cardnotfound] = "#{card["details"]}. Please enter another card name."
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
        c["colors"] != [] ? card.colors = c["colors"] : card.colors = "[\"C\"]"
        card.expansion = c["set_name"]
        card.rarity = c["rarity"].capitalize
        card.flavor_text = c["flavor_text"]
        card.img_url = c["image_uris"]["border_crop"]
        card.power = c["power"]
        card.toughness = c["toughness"]
      }
    end

    def string_to_img_tag(string)
      <<-HTML
        <img height="15" width="15" src="/images/#{string}.png" alt="#{string} mana symbol">
      HTML
    end

    def mana_colors_to_img(string)
      string = "none" if string == nil
      string = eval(string).join("}{").prepend("{") << "}" if string[0] == "["
      string.gsub(/[{].[}]/) do |s|
        i = s.gsub(/[{}]/,"").to_i
        i > 0 ? (0..i.to_i - 1).collect { string_to_img_tag("C") }.join : string_to_img_tag(s.gsub(/[{}]/,""))
      end
    end

    # Deck helper methods

    def checked(deck, color)
      "checked" if deck.color != nil && deck.color.include?(color)
    end

    def card_repl_limit(deck, card)
      exclude = ["Plains", "Swamp", "Island", "Swamp", "Mountain", "Forest"]
      deck.cards.select {|c| c.name == card.name && !exclude.include?(card.name)}.size < 4
    end

    def deck_is_full?(deck)
      deck.size.to_i <= deck.cards.size
    end

  end

end
