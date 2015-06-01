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

ActiveRecord::Schema.define(version: 20150601164609) do

  create_table "addresses", force: :cascade do |t|
    t.integer  "wallet_id",  limit: 4
    t.string   "val",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "outputs", force: :cascade do |t|
    t.integer  "transaction_id",          limit: 4
    t.integer  "address_id",              limit: 4
    t.integer  "value",                   limit: 4
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "as_transaction_input_id", limit: 4
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "unique_hash",   limit: 255
    t.text     "original_json", limit: 65535
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "wallets", force: :cascade do |t|
    t.string   "private_key", limit: 255
    t.string   "public_key",  limit: 255
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
