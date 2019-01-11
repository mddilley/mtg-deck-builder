class User < ActiveRecord::Base

  has_secure_password

  has_many :decks
  has_many :cards, through: :decks

  def self.valid_params?(params)
    params["username"] != "" && params["password"] != "" && params["email"] != ""
  end
  
end
