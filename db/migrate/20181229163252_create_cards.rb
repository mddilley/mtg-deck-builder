class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :mana_cost
      t.string :card_type
      t.string :power
      t.string :toughness
      t.string :rarity
      t.string :expansion
      t.string :card_text
      t.string :colors
      t.string :flavor_text
      t.string :img_url
    end
  end
end
