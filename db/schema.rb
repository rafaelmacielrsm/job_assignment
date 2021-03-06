# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170813011137) do

  create_table "infection_reports", force: :cascade do |t|
    t.integer "survivor_id"
    t.integer "infected_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["infected_id"], name: "index_infection_reports_on_infected_id"
    t.index ["survivor_id", "infected_id"], name: "index_infection_reports_on_survivor_id_and_infected_id", unique: true
    t.index ["survivor_id"], name: "index_infection_reports_on_survivor_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "survivor_id"
    t.integer "item_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survivor_id"], name: "index_items_on_survivor_id"
  end

  create_table "survivors", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.string "longitude"
    t.string "latitude"
    t.boolean "infected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
