class Card < ActiveRecord::Base

  has_many :card_decks
  has_many :decks, through: :card_decks
  

end