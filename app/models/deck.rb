class Deck < ActiveRecord::Base

  has_many :card_decks
  has_many :cards, through: :card_decks
  belongs_to :user

  def self.valid_params?(operator_s, params)
    if operator_s == "&&"
      params[:name].strip != "" && params[:size].strip != ""
    elsif operator_s == "||"
      params[:name].strip == "" || params[:size].strip == ""
    end
  end

  def self.update_deck(deck, params)
    deck.update("name" => params["deck"][:name]) if params["deck"][:name].strip != ""
    deck.update("color" => params["deck"][:color]) if params["deck"][:color] != ""
    deck.update("size" => params["deck"][:size]) if params["deck"][:size].strip != ""
  end

end
