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

ActiveRecord::Schema.define(version: 2023_01_25_182522) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitions", force: :cascade do |t|
    t.string "name"
    t.string "country"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "competseasons", force: :cascade do |t|
    t.bigint "competition_id", null: false
    t.bigint "season_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["competition_id"], name: "index_competseasons_on_competition_id"
    t.index ["season_id"], name: "index_competseasons_on_season_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "player_id", null: false
    t.integer "jerseynumber"
    t.date "startdate"
    t.date "enddate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["player_id"], name: "index_contracts_on_player_id"
    t.index ["team_id"], name: "index_contracts_on_team_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "selection_id", null: false
    t.bigint "eventtype_id", null: false
    t.string "time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "registration"
    t.integer "xpitchcoord"
    t.integer "ypitchcoord"
    t.integer "xcagecoord"
    t.integer "ycagecoord"
    t.float "distance"
    t.integer "goalrank"
    t.index ["eventtype_id"], name: "index_events_on_eventtype_id"
    t.index ["selection_id"], name: "index_events_on_selection_id"
  end

  create_table "eventtypes", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fixtures", force: :cascade do |t|
    t.bigint "hometeam_id", null: false
    t.bigint "awayteam_id", null: false
    t.integer "scorehome"
    t.integer "scoreaway"
    t.bigint "competseason_id", null: false
    t.string "round"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "homeformation"
    t.string "awayformation"
    t.date "date"
    t.boolean "submitted"
    t.bigint "homekit_id"
    t.bigint "awaykit_id"
    t.string "homekit"
    t.string "awaykit"
    t.index ["awaykit_id"], name: "index_fixtures_on_awaykit_id"
    t.index ["awayteam_id"], name: "index_fixtures_on_awayteam_id"
    t.index ["competseason_id"], name: "index_fixtures_on_competseason_id"
    t.index ["homekit_id"], name: "index_fixtures_on_homekit_id"
    t.index ["hometeam_id"], name: "index_fixtures_on_hometeam_id"
  end

  create_table "kits", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "season_id", null: false
    t.string "home_primary_color"
    t.string "home_secondary_color"
    t.string "away_primary_color"
    t.string "away_secondary_color"
    t.string "third_primary_color"
    t.string "third_secondary_color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["season_id"], name: "index_kits_on_season_id"
    t.index ["team_id"], name: "index_kits_on_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "firstname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "playerapiref"
  end

  create_table "positions", force: :cascade do |t|
    t.string "family"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.string "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "selections", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.bigint "fixture_id", null: false
    t.boolean "starter"
    t.integer "substitutiontime"
    t.float "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "substitute_id"
    t.bigint "position_id"
    t.string "grid_pos"
    t.index ["contract_id"], name: "index_selections_on_contract_id"
    t.index ["fixture_id"], name: "index_selections_on_fixture_id"
    t.index ["position_id"], name: "index_selections_on_position_id"
    t.index ["substitute_id"], name: "index_selections_on_substitute_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "shortname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "display_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "firstname"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "competseasons", "competitions"
  add_foreign_key "competseasons", "seasons"
  add_foreign_key "contracts", "players"
  add_foreign_key "contracts", "teams"
  add_foreign_key "events", "eventtypes"
  add_foreign_key "events", "selections"
  add_foreign_key "fixtures", "competseasons"
  add_foreign_key "fixtures", "teams", column: "awayteam_id"
  add_foreign_key "fixtures", "teams", column: "hometeam_id"
  add_foreign_key "kits", "seasons"
  add_foreign_key "kits", "teams"
  add_foreign_key "selections", "contracts"
  add_foreign_key "selections", "fixtures"
  add_foreign_key "selections", "players", column: "substitute_id"
  add_foreign_key "selections", "positions"
end
