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

ActiveRecord::Schema.define(:version => 20111020201930) do

  create_table "meetings", :force => true do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "title"
    t.text     "description"
    t.string   "place"
    t.integer  "total_places"
    t.string   "google_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "up_to_date_with_google", :default => false
    t.boolean  "deleted",                :default => false
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "meeting_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "user_as_host"
  end

  add_index "participations", ["user_id", "meeting_id"], :name => "index_participations_on_user_id_and_meeting_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
