class CreateChampions < ActiveRecord::Migration[8.0]
  def change
    create_table :champions do |t|
      t.string :champion_id, null: false
      t.string :name, null: false
      t.string :title
      t.text :blurb
      t.json :tags
      t.json :passive_data
      t.json :spells_data
      t.string :image_full
      t.datetime :synced_at

      t.timestamps
    end

    add_index :champions, :champion_id, unique: true
    add_index :champions, :name
  end
end
