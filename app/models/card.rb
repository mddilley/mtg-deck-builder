class Card < ActiveRecord::Base

  has_many :card_decks
  has_many :decks, through: :card_decks

  def self.card_name_to_search_name(name)
    name.downcase.split.join("+")
  end

  def self.create_card(card_name)
    url = "https://api.scryfall.com/cards/named?fuzzy=#{Card.card_name_to_search_name(card_name)}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    card = JSON.parse(response)
    if card["status"] == 404
      flash[:cardnotfound] = "#{card["details"]}. Please enter another card name."
      card = nil
    else
      Card.add_card_attr(card)
    end
  end

  def self.add_card_attr(c)
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

end
