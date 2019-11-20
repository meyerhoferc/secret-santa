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

ActiveRecord::Schema.define(version: 2019_11_13_050029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exclusion_teams", force: :cascade do |t|
    t.bigint "group_id"
    t.string "name"
    t.boolean "matched", default: false
    t.datetime "created_at"
    t.index ["group_id"], name: "index_exclusion_teams_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.text "name"
    t.string "description"
    t.bigint "owner_id"
    t.date "gift_due_date"
    t.date "year"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "santas_assigned", default: false
    t.decimal "dollar_limit", precision: 1000, scale: 2
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "receiver_id"
    t.bigint "sender_id"
    t.text "comment"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_invitations_on_group_id"
    t.index ["receiver_id"], name: "index_invitations_on_receiver_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
  end

  create_table "items", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.text "note"
    t.text "size"
    t.bigint "list_id"
    t.index ["list_id"], name: "index_items_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.text "santa_message"
    t.index ["group_id"], name: "index_lists_on_group_id"
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "santa_assignments", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "santa_id"
    t.bigint "receiver_id"
    t.datetime "created_at"
    t.index ["group_id"], name: "index_santa_assignments_on_group_id"
    t.index ["receiver_id"], name: "index_santa_assignments_on_receiver_id"
    t.index ["santa_id"], name: "index_santa_assignments_on_santa_id"
  end

  create_table "user_exclusion_teams", force: :cascade do |t|
    t.integer "user_id"
    t.integer "exclusion_team_id"
    t.index ["exclusion_team_id"], name: "index_user_exclusion_teams_on_exclusion_team_id"
    t.index ["user_id"], name: "index_user_exclusion_teams_on_user_id"
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.index ["group_id"], name: "index_user_groups_on_group_id"
    t.index ["user_id"], name: "index_user_groups_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "password_confirmation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "username"
    t.boolean "disable_email", default: false
  end

  add_foreign_key "exclusion_teams", "groups"
  add_foreign_key "groups", "users", column: "owner_id"
  add_foreign_key "invitations", "groups"
  add_foreign_key "invitations", "users", column: "receiver_id"
  add_foreign_key "invitations", "users", column: "sender_id"
  add_foreign_key "items", "lists"
  add_foreign_key "lists", "groups"
  add_foreign_key "lists", "users"
  add_foreign_key "santa_assignments", "groups"
  add_foreign_key "santa_assignments", "users", column: "receiver_id"
  add_foreign_key "santa_assignments", "users", column: "santa_id"
end
