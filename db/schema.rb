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

ActiveRecord::Schema.define(version: 2021_12_03_161523) do

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

  create_table "fixtures", force: :cascade do |t|
    t.bigint "hometeam_id", null: false
    t.bigint "awayteam_id", null: false
    t.integer "scorehome"
    t.integer "scoreaway"
    t.bigint "competseason_id", null: false
    t.integer "round"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["awayteam_id"], name: "index_fixtures_on_awayteam_id"
    t.index ["competseason_id"], name: "index_fixtures_on_competseason_id"
    t.index ["hometeam_id"], name: "index_fixtures_on_hometeam_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "firstname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "seasons", force: :cascade do |t|
    t.string "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "shortname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "competseasons", "competitions"
  add_foreign_key "competseasons", "seasons"
  add_foreign_key "fixtures", "competseasons"
  add_foreign_key "fixtures", "teams", column: "awayteam_id"
  add_foreign_key "fixtures", "teams", column: "hometeam_id"
end
