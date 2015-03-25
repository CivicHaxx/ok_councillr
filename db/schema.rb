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

ActiveRecord::Schema.define(version: 20150324233543) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agendas", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "committee_id"
    t.string   "meeting_num"
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
    t.integer  "ward_id"
  end

  add_index "councillors", ["ward_id"], name: "index_councillors_on_ward_id", using: :btree

  create_table "dirty_agendas", force: :cascade do |t|
    t.integer "meeting_id"
    t.text    "dirty_html"
  end

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string   "number"
    t.string   "title"
    t.text     "sections"
    t.integer  "item_type_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "origin_id"
    t.string   "origin_type"
  end

  add_index "items", ["item_type_id"], name: "index_items_on_item_type_id", using: :btree
  add_index "items", ["origin_type", "origin_id"], name: "index_items_on_origin_type_and_origin_id", using: :btree

  create_table "items_wards", id: false, force: :cascade do |t|
    t.integer "ward_id", null: false
    t.integer "item_id", null: false
  end

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

  create_table "raw_vote_records", force: :cascade do |t|
    t.string  "committee"
    t.string  "date_time"
    t.string  "agenda_item"
    t.text    "agenda_item_title"
    t.string  "motion_type"
    t.string  "vote"
    t.string  "result"
    t.text    "vote_description"
    t.integer "councillor_id"
  end

  add_index "raw_vote_records", ["councillor_id"], name: "index_raw_vote_records_on_councillor_id", using: :btree

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
    t.string   "email",                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "first_name",                      null: false
    t.string   "last_name",                       null: false
    t.string   "street_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.integer  "street_num"
    t.integer  "ward_id"
  end

  add_index "users", ["activation_token"], name: "index_users_on_activation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  add_index "users", ["ward_id"], name: "index_users_on_ward_id", using: :btree

  create_table "wards", force: :cascade do |t|
    t.integer  "ward_number"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "agendas", "committees"
  add_foreign_key "councillor_votes", "councillors"
  add_foreign_key "councillor_votes", "motions"
  add_foreign_key "councillors", "wards"
  add_foreign_key "motions", "councillors"
  add_foreign_key "motions", "items"
  add_foreign_key "motions", "motion_types"
  add_foreign_key "raw_vote_records", "councillors"
  add_foreign_key "users", "wards"
end
