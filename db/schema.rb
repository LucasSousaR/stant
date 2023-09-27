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

ActiveRecord::Schema[7.0].define(version: 2023_09_27_051332) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "integrations", force: :cascade do |t|
    t.string "name"
    t.string "type_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "name"
    t.string "am_pm"
    t.integer "start"
    t.integer "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "speeches", force: :cascade do |t|
    t.string "name"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "check_session"
  end

  create_table "track_session_speeches", force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "session_id"
    t.bigint "speech_id"
    t.string "initial_hour"
    t.string "finish_hour"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_track_session_speeches_on_session_id"
    t.index ["speech_id"], name: "index_track_session_speeches_on_speech_id"
    t.index ["track_id"], name: "index_track_session_speeches_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "name"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "check_am"
    t.boolean "check_pm"
  end

  add_foreign_key "track_session_speeches", "sessions"
  add_foreign_key "track_session_speeches", "speeches"
  add_foreign_key "track_session_speeches", "tracks"
end
