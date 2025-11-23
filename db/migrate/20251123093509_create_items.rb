class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.integer :item_id, null: false
      t.string :name, null: false
      t.text :description
      t.text :plaintext
      t.json :gold
      t.json :stats
      t.json :tags
      t.string :image_full
      t.boolean :purchasable, default: true
      t.json :into
      t.json :from
      t.datetime :synced_at

      t.timestamps
    end

    add_index :items, :item_id, unique: true
    add_index :items, :name
  end
end
