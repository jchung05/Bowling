# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160107065656) do

  create_table "games", force: :cascade do |t|
    t.integer  "index",           default: 0
    t.integer  "score",           default: 0
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "name"
    t.integer  "pinsKnockedOver", default: 0
    t.integer  "totalPins",       default: 10
  end

  create_table "rolls", force: :cascade do |t|
    t.integer  "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "frameScore"
    t.integer  "pinsLeft"
  end

end
