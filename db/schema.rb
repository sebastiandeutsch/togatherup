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

ActiveRecord::Schema[8.0].define(version: 2024_10_01_008000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "identified_by"
    t.jsonb "metadata"
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
    t.string "identified_by"
    t.jsonb "analyzed_metadata"
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "availability_slots", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "day_of_week", null: false
    t.time "starts_at", null: false
    t.time "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "day_of_week"], name: "index_availability_slots_on_user_id_and_day_of_week"
    t.index ["user_id"], name: "index_availability_slots_on_user_id"
  end

  create_table "event_time_suggestions", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_time_suggestions_on_event_id"
  end

  create_table "event_votes", force: :cascade do |t|
    t.bigint "event_time_suggestion_id", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "tentative", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_time_suggestion_id", "user_id"], name: "index_event_votes_on_suggestion_and_user", unique: true
    t.index ["event_time_suggestion_id"], name: "index_event_votes_on_event_time_suggestion_id"
    t.index ["user_id"], name: "index_event_votes_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "creator_id", null: false
    t.string "name", null: false
    t.text "description"
    t.boolean "require_everyone", default: false, null: false
    t.boolean "requires_contribution", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_events_on_creator_id"
    t.index ["group_id"], name: "index_events_on_group_id"
  end

  create_table "group_invitations", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "sender_id", null: false
    t.string "email"
    t.string "token", null: false
    t.datetime "accepted_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_invitations_on_group_id"
    t.index ["sender_id"], name: "index_group_invitations_on_sender_id"
    t.index ["token"], name: "index_group_invitations_on_token", unique: true
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "joined_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_memberships_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "availability_slots", "users"
  add_foreign_key "event_time_suggestions", "events"
  add_foreign_key "event_votes", "event_time_suggestions"
  add_foreign_key "event_votes", "users"
  add_foreign_key "events", "groups"
  add_foreign_key "events", "users", column: "creator_id"
  add_foreign_key "group_invitations", "groups"
  add_foreign_key "group_invitations", "users", column: "sender_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "groups", "users", column: "owner_id"
end
