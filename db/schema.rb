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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130704034732) do

  create_table "buildings", :force => true do |t|
    t.string   "title"
    t.string   "address"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "buildings", ["organization_id"], :name => "index_buildings_on_organization_id"

  create_table "classrooms", :force => true do |t|
    t.string   "number"
    t.integer  "building_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "classrooms", ["building_id"], :name => "index_classrooms_on_building_id"

  create_table "days", :force => true do |t|
    t.integer  "week_id"
    t.date     "date"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "days", ["week_id"], :name => "index_days_on_week_id"

  create_table "lecturers", :force => true do |t|
    t.string   "name"
    t.string   "patronymic"
    t.string   "surname"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "lecturers", ["organization_id"], :name => "index_lecturers_on_organization_id"

  create_table "lesson_times", :force => true do |t|
    t.integer  "context_id"
    t.string   "context_type"
    t.string   "starts_at"
    t.string   "ends_at"
    t.integer  "day"
    t.integer  "number"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "lesson_times", ["context_id"], :name => "index_lesson_times_on_context_id"
  add_index "lesson_times", ["context_type"], :name => "index_lesson_times_on_context_type"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.string   "role"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "email"
  end

  add_index "memberships", ["organization_id"], :name => "index_memberships_on_organization_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "organizations", :force => true do |t|
    t.text     "title"
    t.string   "email"
    t.string   "phone"
    t.string   "site"
    t.string   "subdomain"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "timetables", :force => true do |t|
    t.integer  "organization_id"
    t.string   "title"
    t.date     "starts_on"
    t.date     "ends_on"
    t.string   "status"
    t.boolean  "parity"
    t.integer  "first_week_parity"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "timetables", ["organization_id"], :name => "index_timetables_on_organization_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "weeks", :force => true do |t|
    t.integer  "timetable_id"
    t.integer  "number"
    t.date     "starts_on"
    t.string   "parity"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "weeks", ["timetable_id"], :name => "index_weeks_on_timetable_id"

end
