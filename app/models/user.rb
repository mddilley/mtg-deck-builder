class User < ActiveRecord::Base

  has_secure_password

  has_many :decks
  has_many :cards, through: :decks

  def self.valid_params?(params)
    params.each.select {|k,v| v == "" } == []
  end

end
