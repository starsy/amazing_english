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

ActiveRecord::Schema.define(version: 20150515112206) do

  create_table "answers", force: :cascade do |t|
    t.text     "text",       limit: 65535
    t.string   "trainee",    limit: 255
    t.float    "score",      limit: 24
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "event_id",   limit: 4
    t.boolean  "is_active",  limit: 1
  end

  add_index "answers", ["event_id"], name: "index_answers_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.text     "title",                 limit: 65535
    t.date     "date"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "trainer",               limit: 255
    t.boolean  "is_solution_published", limit: 1
    t.boolean  "is_closed",             limit: 1
  end

  add_index "events", ["id"], name: "index_events_on_id", unique: true, using: :btree

  create_table "solutions", force: :cascade do |t|
    t.text     "text",       limit: 65535
    t.string   "provider",   limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "event_id",   limit: 4
  end

  add_index "solutions", ["event_id"], name: "index_solutions_on_event_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",            limit: 255, null: false
    t.string   "crypted_password", limit: 255
    t.string   "salt",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
