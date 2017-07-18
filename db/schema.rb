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

ActiveRecord::Schema.define(version: 20170718000502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "locations", force: true do |t|
    t.string "name"
    t.string "description"
    t.string "hero_url"
    t.string "city"
    t.string "state"
  end

  create_table "mentors", force: true do |t|
    t.integer  "mentor_id"
    t.integer  "mentee_id"
    t.text     "question"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peer_group_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "peer_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "peer_groups", force: true do |t|
    t.integer  "peer1_id"
    t.integer  "peer2_id"
    t.integer  "peer3_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "peer4_id"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                  default: "",    null: false
    t.string   "encrypted_password",                     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "mentor",                                 default: false
    t.string   "primary_industry"
    t.integer  "stage_of_career"
    t.string   "mentor_industry"
    t.string   "peer_industry"
    t.string   "current_goal"
    t.text     "top_3_interests",                        default: [],                 array: true
    t.boolean  "live_in_detroit",                        default: true
    t.boolean  "waitlist",                               default: true
    t.boolean  "is_assigned_peer_group",                 default: false
    t.integer  "mentor_times",                           default: 1
    t.integer  "mentor_limit",                           default: 1
    t.boolean  "is_participating_this_month"
    t.string   "image_url"
    t.integer  "location_id"
    t.string   "zip_code",                    limit: 10
    t.string   "linkedin_url"
    t.boolean  "wants_mentor",                           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["location_id"], name: "index_users_on_location_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
