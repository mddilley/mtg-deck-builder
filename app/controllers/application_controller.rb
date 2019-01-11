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

    def valid_deck_params?(comparison_string)
      if comparison_string == "&&"
        params[:name].strip != "" && params[:size].strip != ""
      elsif comparison_string == "||"
        params[:name].strip == "" || params[:size].strip == ""
      end
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
