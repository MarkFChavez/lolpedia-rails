class CreateSummonerSpells < ActiveRecord::Migration[8.0]
  def change
    create_table :summoner_spells do |t|
      t.string :spell_id
      t.string :key
      t.string :name
      t.text :description
      t.json :cooldown
      t.json :range
      t.string :image_full
      t.integer :summoner_level
      t.json :modes
      t.datetime :synced_at

      t.timestamps
    end
    add_index :summoner_spells, :spell_id, unique: true
    add_index :summoner_spells, :name
  end
end
