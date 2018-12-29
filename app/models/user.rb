class User < ActiveRecord::Base

  has_secure_password

  has_many :decks
  has_many :cards, through: :decks

end
