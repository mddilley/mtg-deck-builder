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

    def redirect_to_login
      if !is_loggedin?
        flash[:not_logged_in] = "Please login to continue."
        redirect to "/users/login"
      end
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

  end

end
