# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_09_12_092455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_activities_on_name", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "subject_type"
    t.bigint "subject_id"
    t.text "name"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_type", "subject_id"], name: "index_locations_on_subject_type_and_subject_id"
  end

  create_table "problems", force: :cascade do |t|
    t.string "subject_type"
    t.bigint "subject_id"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["state"], name: "index_problems_on_state"
    t.index ["subject_type", "subject_id"], name: "index_problems_on_subject_type_and_subject_id"
  end

  create_table "project_activities", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "activity_id"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order"
    t.index ["activity_id"], name: "index_project_activities_on_activity_id"
    t.index ["order"], name: "index_project_activities_on_order"
    t.index ["project_id"], name: "index_project_activities_on_project_id"
    t.index ["state"], name: "index_project_activities_on_state"
  end

  create_table "project_questions", force: :cascade do |t|
    t.string "subject_type"
    t.bigint "subject_id"
    t.bigint "question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "order"
    t.index ["order"], name: "index_project_questions_on_order"
    t.index ["question_id"], name: "index_project_questions_on_question_id"
    t.index ["subject_type", "subject_id"], name: "index_project_questions_on_subject_type_and_subject_id"
  end

  create_table "project_types", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_project_types_on_name", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "project_type_id"
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_projects_on_name"
    t.index ["project_type_id"], name: "index_projects_on_project_type_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "topic_id"
    t.text "text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "scoped_to_role_ids", array: true
    t.index ["scoped_to_role_ids"], name: "index_questions_on_scoped_to_role_ids"
    t.index ["topic_id", "text"], name: "index_questions_on_topic_id_and_text", unique: true
    t.index ["topic_id"], name: "index_questions_on_topic_id"
  end

  create_table "response_triggers", force: :cascade do |t|
    t.bigint "question_id"
    t.text "value"
    t.string "event_name"
    t.json "event_params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_name"], name: "index_response_triggers_on_event_name"
    t.index ["question_id"], name: "index_response_triggers_on_question_id"
  end

  create_table "responses", force: :cascade do |t|
    t.bigint "project_question_id"
    t.bigint "user_id"
    t.text "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_question_id"], name: "index_responses_on_project_question_id"
    t.index ["user_id"], name: "index_responses_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.string "scope_type"
    t.bigint "scope_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["scope_type", "scope_id"], name: "index_user_roles_on_scope_type_and_scope_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_users_on_name"
  end

end
