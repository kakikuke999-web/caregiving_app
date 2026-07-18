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

ActiveRecord::Schema[7.1].define(version: 2026_07_18_012508) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "adl_records", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "recorded_by_id", null: false
    t.datetime "recorded_at"
    t.integer "meal_intake"
    t.integer "excretion_status"
    t.integer "sleep_quality"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bathed"
    t.boolean "medication_taken"
    t.integer "urination_count"
    t.boolean "bowel_movement"
    t.integer "breakfast_staple"
    t.integer "breakfast_side"
    t.integer "lunch_staple"
    t.integer "lunch_side"
    t.integer "dinner_staple"
    t.integer "dinner_side"
    t.index ["care_recipient_id"], name: "index_adl_records_on_care_recipient_id"
    t.index ["recorded_by_id"], name: "index_adl_records_on_recorded_by_id"
  end

  create_table "care_documents", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "uploaded_by_id", null: false
    t.string "document_type", null: false
    t.string "title"
    t.string "issuing_organization"
    t.date "issued_on"
    t.date "valid_from"
    t.date "valid_until"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_care_documents_on_care_recipient_id"
    t.index ["uploaded_by_id"], name: "index_care_documents_on_uploaded_by_id"
  end

  create_table "care_plan_goals", force: :cascade do |t|
    t.bigint "care_plan_id", null: false
    t.text "issue"
    t.text "long_term_goal"
    t.string "long_term_goal_period"
    t.text "short_term_goal"
    t.string "short_term_goal_period"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_plan_id"], name: "index_care_plan_goals_on_care_plan_id"
  end

  create_table "care_plan_services", force: :cascade do |t|
    t.bigint "care_plan_goal_id", null: false
    t.text "content"
    t.string "category"
    t.string "provider"
    t.string "frequency"
    t.string "period"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_plan_goal_id"], name: "index_care_plan_services_on_care_plan_goal_id"
  end

  create_table "care_plans", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.date "created_on"
    t.string "office_name"
    t.text "policy_summary"
    t.text "family_intention"
    t.text "certification_committee_opinion"
    t.string "assistance_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "created_by_id", null: false
    t.index ["care_recipient_id"], name: "index_care_plans_on_care_recipient_id"
    t.index ["created_by_id"], name: "index_care_plans_on_created_by_id"
  end

  create_table "care_recipient_visit_types", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "visit_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_care_recipient_visit_types_on_care_recipient_id"
    t.index ["visit_type_id"], name: "index_care_recipient_visit_types_on_visit_type_id"
  end

  create_table "care_recipients", force: :cascade do |t|
    t.string "name"
    t.date "dob"
    t.text "allergies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.string "care_level"
    t.date "birthday"
    t.text "memo"
    t.text "medical_history"
    t.string "primary_doctor"
    t.string "primary_hospital"
    t.text "regular_medications"
    t.bigint "primary_care_manager_id"
    t.date "care_level_valid_until"
    t.string "name_kana"
    t.string "insurer_number"
    t.string "insured_person_number"
    t.integer "benefit_limit_units"
    t.string "gender"
    t.index ["primary_care_manager_id"], name: "index_care_recipients_on_primary_care_manager_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "visit_report_id", null: false
    t.bigint "user_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["visit_report_id"], name: "index_comments_on_visit_report_id"
  end

  create_table "emergency_contacts", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.string "name"
    t.string "relationship"
    t.string "phone_number"
    t.integer "priority", default: 1, null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_emergency_contacts_on_care_recipient_id"
  end

  create_table "family_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "care_recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_family_memberships_on_care_recipient_id"
    t.index ["user_id", "care_recipient_id"], name: "index_family_memberships_on_user_id_and_care_recipient_id", unique: true
    t.index ["user_id"], name: "index_family_memberships_on_user_id"
  end

  create_table "medication_records", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "recorded_by_id", null: false
    t.datetime "recorded_at"
    t.string "medication_name"
    t.boolean "taken", default: true, null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_medication_records_on_care_recipient_id"
    t.index ["recorded_by_id"], name: "index_medication_records_on_recorded_by_id"
  end

  create_table "personal_schedules", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "created_by_id", null: false
    t.string "title"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_personal_schedules_on_care_recipient_id"
    t.index ["created_by_id"], name: "index_personal_schedules_on_created_by_id"
  end

  create_table "recurring_schedules", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "visit_type_id", null: false
    t.bigint "user_id"
    t.bigint "created_by_id", null: false
    t.integer "day_of_week", null: false
    t.time "start_time", null: false
    t.time "end_time"
    t.string "provider_name"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_recurring_schedules_on_care_recipient_id"
    t.index ["created_by_id"], name: "index_recurring_schedules_on_created_by_id"
    t.index ["user_id"], name: "index_recurring_schedules_on_user_id"
    t.index ["visit_type_id"], name: "index_recurring_schedules_on_visit_type_id"
  end

  create_table "support_logs", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "user_id", null: false
    t.datetime "occurred_at"
    t.string "category"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["care_recipient_id"], name: "index_support_logs_on_care_recipient_id"
    t.index ["user_id"], name: "index_support_logs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.string "name"
    t.boolean "alert_emails_enabled", default: true, null: false
    t.date "last_alert_email_sent_on"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visit_reports", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "user_id"
    t.text "notes"
    t.datetime "visited_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "visit_type_id"
    t.integer "status", default: 0, null: false
    t.datetime "ended_at"
    t.string "provider_name"
    t.bigint "recurring_schedule_id"
    t.boolean "is_monitoring", default: false, null: false
    t.index ["care_recipient_id"], name: "index_visit_reports_on_care_recipient_id"
    t.index ["recurring_schedule_id"], name: "index_visit_reports_on_recurring_schedule_id"
    t.index ["user_id"], name: "index_visit_reports_on_user_id"
    t.index ["visit_type_id"], name: "index_visit_reports_on_visit_type_id"
  end

  create_table "visit_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "unit_count"
  end

  create_table "vitals", force: :cascade do |t|
    t.bigint "care_recipient_id", null: false
    t.bigint "recorded_by_id", null: false
    t.datetime "recorded_at"
    t.string "type"
    t.decimal "value", precision: 6, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "systolic"
    t.integer "diastolic"
    t.text "note"
    t.index ["care_recipient_id"], name: "index_vitals_on_care_recipient_id"
    t.index ["recorded_by_id"], name: "index_vitals_on_recorded_by_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adl_records", "care_recipients"
  add_foreign_key "adl_records", "users", column: "recorded_by_id"
  add_foreign_key "care_documents", "care_recipients"
  add_foreign_key "care_documents", "users", column: "uploaded_by_id"
  add_foreign_key "care_plan_goals", "care_plans"
  add_foreign_key "care_plan_services", "care_plan_goals"
  add_foreign_key "care_plans", "care_recipients"
  add_foreign_key "care_plans", "users", column: "created_by_id"
  add_foreign_key "care_recipient_visit_types", "care_recipients"
  add_foreign_key "care_recipient_visit_types", "visit_types"
  add_foreign_key "care_recipients", "users", column: "primary_care_manager_id"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "visit_reports"
  add_foreign_key "emergency_contacts", "care_recipients"
  add_foreign_key "family_memberships", "care_recipients"
  add_foreign_key "family_memberships", "users"
  add_foreign_key "medication_records", "care_recipients"
  add_foreign_key "medication_records", "users", column: "recorded_by_id"
  add_foreign_key "personal_schedules", "care_recipients"
  add_foreign_key "personal_schedules", "users", column: "created_by_id"
  add_foreign_key "recurring_schedules", "care_recipients"
  add_foreign_key "recurring_schedules", "users"
  add_foreign_key "recurring_schedules", "users", column: "created_by_id"
  add_foreign_key "recurring_schedules", "visit_types"
  add_foreign_key "support_logs", "care_recipients"
  add_foreign_key "support_logs", "users"
  add_foreign_key "visit_reports", "care_recipients"
  add_foreign_key "visit_reports", "recurring_schedules"
  add_foreign_key "visit_reports", "users"
  add_foreign_key "visit_reports", "visit_types"
  add_foreign_key "vitals", "care_recipients"
  add_foreign_key "vitals", "users", column: "recorded_by_id"
end
