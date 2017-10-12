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

ActiveRecord::Schema.define(version: 20171005065503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.string "authors"
    t.string "genres"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string "name"
    t.boolean "available"
    t.string "genres"
    t.string "authors"
    t.string "publisher"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "single_sorts", force: :cascade do |t|
    t.bigint "list_id"
    t.bigint "book_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_single_sorts_on_book_id"
    t.index ["list_id"], name: "index_single_sorts_on_list_id"
  end

  add_foreign_key "single_sorts", "books"
  add_foreign_key "single_sorts", "lists"
end
