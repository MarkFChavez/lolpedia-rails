# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_23_093509) do
  create_table "champions", force: :cascade do |t|
    t.string "champion_id", null: false
    t.string "name", null: false
    t.string "title"
    t.text "blurb"
    t.json "tags"
    t.json "passive_data"
    t.json "spells_data"
    t.string "image_full"
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["champion_id"], name: "index_champions_on_champion_id", unique: true
    t.index ["name"], name: "index_champions_on_name"
  end

  create_table "items", force: :cascade do |t|
    t.integer "item_id", null: false
    t.string "name", null: false
    t.text "description"
    t.text "plaintext"
    t.json "gold"
    t.json "stats"
    t.json "tags"
    t.string "image_full"
    t.boolean "purchasable", default: true
    t.json "into"
    t.json "from"
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_items_on_item_id", unique: true
    t.index ["name"], name: "index_items_on_name"
  end
end
