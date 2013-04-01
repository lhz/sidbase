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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130401181904) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.string   "handle"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authors", ["handle"], :name => "index_authors_on_handle"
  add_index "authors", ["name"], :name => "index_authors_on_name"

  create_table "authors_tunes", :id => false, :force => true do |t|
    t.integer "author_id"
    t.integer "tune_id"
  end

  add_index "authors_tunes", ["author_id", "tune_id"], :name => "index_authors_tunes_on_author_id_and_tune_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "companies", ["name"], :name => "index_companies_on_name"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "groups", ["name"], :name => "index_groups_on_name"

  create_table "groups_tunes", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "tune_id"
  end

  add_index "groups_tunes", ["group_id", "tune_id"], :name => "index_groups_tunes_on_group_id_and_tune_id"

  create_table "tunes", :force => true do |t|
    t.string   "name"
    t.string   "author"
    t.string   "released"
    t.string   "path"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "size"
    t.string   "year"
    t.integer  "load"
    t.integer  "init"
    t.integer  "play"
    t.integer  "songs"
    t.string   "model"
  end

  add_index "tunes", ["author"], :name => "index_tunes_on_author"
  add_index "tunes", ["name"], :name => "index_tunes_on_name"
  add_index "tunes", ["released"], :name => "index_tunes_on_released"

end
