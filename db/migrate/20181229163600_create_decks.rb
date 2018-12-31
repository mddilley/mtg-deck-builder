class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.string :name
      t.string :size
      t.string :color
      t.integer :user_id
    end
  end
end
