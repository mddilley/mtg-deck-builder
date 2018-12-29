class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.string :mana_cost
      t.string :type
      t.string :power_toughness
      t.string :rarity
      t.string :expansion
      t.string :card_text
    end
  end
end
