# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_08_08_170803) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "user_cumulative_spending_info", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "amount_spent_in_domestic_country", default: 0, null: false
    t.integer "amount_spent_in_foreign_countries", default: 0, null: false
    t.jsonb "transactions_count_info", default: {}, null: false
    t.jsonb "current_quarter_info", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_cumulative_spending_info_on_user_id"
  end

  create_table "user_loyalty_points_accumulation_info", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "current_cycle_loyalty_points", default: 0, null: false
    t.integer "last_cycle_loyalty_points", default: 0, null: false
    t.jsonb "current_month_info", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_loyalty_points_accumulation_info_on_user_id"
  end

  create_table "user_loyalty_points_transactions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "loyalty_points", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_loyalty_points_transactions_on_user_id"
  end

  create_table "user_rewards", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.integer "reward", null: false
    t.date "will_expire_on"
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "reward", "will_expire_on"], name: "index_user_rewards_on_user_id_and_reward_and_will_expire_on", unique: true
    t.index ["user_id"], name: "index_user_rewards_on_user_id"
  end

  create_table "user_transactions", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "country_code", null: false
    t.integer "amount", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_transactions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.date "date_of_birth", null: false
    t.string "country_code", null: false
    t.integer "current_tier", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date_of_birth"], name: "index_users_on_date_of_birth"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "user_cumulative_spending_info", "users", on_delete: :restrict
  add_foreign_key "user_loyalty_points_accumulation_info", "users", on_delete: :restrict
  add_foreign_key "user_loyalty_points_transactions", "users", on_delete: :restrict
  add_foreign_key "user_rewards", "users", on_delete: :restrict
  add_foreign_key "user_transactions", "users", on_delete: :restrict
end
