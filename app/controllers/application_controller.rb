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

    def card_name_to_search_name(name)
      name.downcase.split.join("+")
    end

    def create_card(card_name)
      url = "https://api.scryfall.com/cards/named?fuzzy=#{card_name_to_search_name(card_name)}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      c = JSON.parse(response)
      Card.create("name" => c["name"]).tap { |card|
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

  end

end
