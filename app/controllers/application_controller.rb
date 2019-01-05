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

    def is_object?(object)
      !!object.id rescue false
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
        c["colors"] != [] ? card.colors = c["colors"] : card.colors = "{C}"
        card.expansion = c["set_name"]
        card.rarity = c["rarity"].capitalize
        card.flavor_text = c["flavor_text"]
        card.img_url = c["image_uris"]["border_crop"]
        card.power = c["power"]
        card.toughness = c["toughness"]
      }
    end

    def convert_colors(c)
      if is_object?(c)
        colors = eval(c.colors)
      elsif c.is_a?(Array)
        colors = c
      end
      colors.map do |c|
        c == "G" ? c = "Green" : c
        c == "W" ? c = "White" : c
        c == "B" ? c = "Black" : c
        c == "R" ? c = "Red" : c
        c == "U" ? c = "Blue" : c
      end
      colors.join(" / ")
    end

    def string_to_img_tag(string)
      <<-HTML
        <img height="15" width="15" src="/images/#{string}.png" alt="#{string} mana symbol">
      HTML
    end

    def mana_colors_to_img(string)
      if string[0] == "["
        string = eval(string).join("}{").prepend("{") << "}"
      end
      string.gsub(/[{].[}]/) do |s|
        i = s.gsub(/[{}]/,"").to_i
        i > 0 ? (0..i.to_i - 1).collect { string_to_img_tag("C") }.join : string_to_img_tag(s.gsub(/[{}]/,""))
      end
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
