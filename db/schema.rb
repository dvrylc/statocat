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

ActiveRecord::Schema.define(version: 20150320045852) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "user_statistics", force: :cascade do |t|
    t.integer  "user_id"
    t.json     "repo_lang"
    t.json     "code_lang"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "total_stars",   default: 0
    t.integer  "total_repos",   default: 0
    t.float    "average_stars"
  end

  add_index "user_statistics", ["user_id"], name: "index_user_statistics_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "username"
    t.integer  "followers"
    t.integer  "following"
    t.datetime "join_date"
    t.integer  "public_repos"
    t.integer  "public_gists"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "avatar"
  end

  add_foreign_key "user_statistics", "users"
end
