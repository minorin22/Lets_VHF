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

ActiveRecord::Schema.define(version: 2018_12_18_035858) do

  create_table "dscs", force: :cascade do |t|
    t.integer "from_id"
    t.integer "to_id"
    t.string "category"
    t.string "format"
    t.integer "work_ch"
    t.string "reason"
    t.string "eos"
    t.string "nature"
    t.float "lat"
    t.float "long"
    t.float "utc"
    t.integer "dist_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message_type"
    t.integer "original_id"
  end

  create_table "stations", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "call_sign"
    t.integer "mmsi"
    t.float "lat"
    t.float "long"
    t.string "region"
    t.integer "channel"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state"
    t.integer "tmp_ch"
    t.integer "power"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
  end

end
