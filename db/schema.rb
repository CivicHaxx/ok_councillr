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

ActiveRecord::Schema.define(version: 201503111185126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendas", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "committee_id"
  end

  add_index "agendas", ["committee_id"], name: "index_agendas_on_committee_id", using: :btree

  create_table "committees", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "committees_councillors", id: false, force: :cascade do |t|
    t.integer "committee_id",  null: false
    t.integer "councillor_id", null: false
  end

  create_table "councillor_votes", force: :cascade do |t|
    t.string   "vote"
    t.integer  "motion_id"
    t.integer  "councillor_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "councillor_votes", ["councillor_id"], name: "index_councillor_votes_on_councillor_id", using: :btree
  add_index "councillor_votes", ["motion_id"], name: "index_councillor_votes_on_motion_id", using: :btree

  create_table "councillors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "ward"
    t.date     "start_date_in_office"
    t.string   "website"
    t.string   "twitter_handle"
    t.string   "facebook_handle"
    t.string   "email"
    t.string   "phone_number"
    t.string   "address"
    t.string   "image"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "number"
    t.string   "title"
    t.string   "ward"
    t.text     "sections"
    t.text     "recommendations"
    t.integer  "item_type_id"
    t.integer  "agenda_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "items", ["agenda_id"], name: "index_items_on_agenda_id", using: :btree
  add_index "items", ["item_type_id"], name: "index_items_on_item_type_id", using: :btree

  create_table "motion_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "motions", force: :cascade do |t|
    t.string   "amendment_text"
    t.integer  "councillor_id"
    t.integer  "item_id"
    t.integer  "motion_type_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "motions", ["councillor_id"], name: "index_motions_on_councillor_id", using: :btree
  add_index "motions", ["item_id"], name: "index_motions_on_item_id", using: :btree
  add_index "motions", ["motion_type_id"], name: "index_motions_on_motion_type_id", using: :btree

  create_table "user_votes", force: :cascade do |t|
    t.string   "vote",       null: false
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_votes", ["item_id"], name: "index_user_votes_on_item_id", using: :btree
  add_index "user_votes", ["user_id"], name: "index_user_votes_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "first_name",       null: false
    t.string   "last_name",        null: false
    t.string   "postal_code"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "agendas", "committees"
  add_foreign_key "councillor_votes", "councillors"
  add_foreign_key "councillor_votes", "motions"
  add_foreign_key "motions", "councillors"
  add_foreign_key "motions", "items"
  add_foreign_key "motions", "motion_types"
end
