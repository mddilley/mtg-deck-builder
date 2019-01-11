class Deck < ActiveRecord::Base

  CARD_REPL_LIMIT = 4

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

  def self.card_repl_limit?(deck, card)
    exclude = ["Plains", "Swamp", "Island", "Swamp", "Mountain", "Forest"]
    deck.cards.select {|c| c.name == card.name && !exclude.include?(card.name)}.size >= CARD_REPL_LIMIT if card != nil
  end

  def self.deck_is_full?(deck)
    deck.size.to_i <= deck.cards.size
  end

  def self.add_card_to_deck(deck, params)
    if params["card"][:name] != ""
      Card.create_card(params["card"]["name"]).tap { |card|
        deck.cards << card if card != nil && !Deck.card_repl_limit?(deck, card) && !Deck.deck_is_full?(deck)
      }
    elsif params["card"][:id] != ""
      Card.find(params["card"][:id]).tap { |card|
        deck.cards << card if card != nil && !Deck.card_repl_limit?(deck, card) && !Deck.deck_is_full?(deck)
      }
    end
  end

end
