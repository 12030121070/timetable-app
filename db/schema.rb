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

ActiveRecord::Schema.define(:version => 20130829022245) do

  create_table "buildings", :force => true do |t|
    t.string   "title"
    t.string   "address"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "buildings", ["organization_id"], :name => "index_buildings_on_organization_id"

  create_table "classroom_lessons", :force => true do |t|
    t.integer  "classroom_id"
    t.integer  "lesson_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "classroom_lessons", ["classroom_id"], :name => "index_classroom_lessons_on_classroom_id"
  add_index "classroom_lessons", ["lesson_id"], :name => "index_classroom_lessons_on_lesson_id"

  create_table "classrooms", :force => true do |t|
    t.string   "number"
    t.integer  "building_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "classrooms", ["building_id", "number"], :name => "index_classrooms_on_building_id_and_number", :unique => true
  add_index "classrooms", ["building_id"], :name => "index_classrooms_on_building_id"

  create_table "days", :force => true do |t|
    t.integer  "week_id"
    t.date     "date"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "days", ["week_id"], :name => "index_days_on_week_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "disciplines", :force => true do |t|
    t.text     "title"
    t.integer  "organization_id"
    t.string   "abbr"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "disciplines", ["organization_id"], :name => "index_disciplines_on_organization_id"

  create_table "group_lessons", :force => true do |t|
    t.integer  "group_id"
    t.integer  "lesson_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "group_lessons", ["group_id"], :name => "index_group_lessons_on_group_id"
  add_index "group_lessons", ["lesson_id"], :name => "index_group_lessons_on_lesson_id"

  create_table "groups", :force => true do |t|
    t.string   "title"
    t.integer  "timetable_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "groups", ["timetable_id"], :name => "index_groups_on_timetable_id"

  create_table "holidays", :force => true do |t|
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
  end

  create_table "lecturer_lessons", :force => true do |t|
    t.integer  "lesson_id"
    t.integer  "lecturer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "lecturer_lessons", ["lecturer_id"], :name => "index_lecturer_lessons_on_lecturer_id"
  add_index "lecturer_lessons", ["lesson_id"], :name => "index_lecturer_lessons_on_lesson_id"

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

  create_table "lessons", :force => true do |t|
    t.integer  "day_id"
    t.integer  "discipline_id"
    t.integer  "lesson_time_id"
    t.string   "kind"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "subgroup"
  end

  add_index "lessons", ["day_id"], :name => "index_lessons_on_day_id"
  add_index "lessons", ["discipline_id"], :name => "index_lessons_on_discipline_id"
  add_index "lessons", ["lesson_time_id"], :name => "index_lessons_on_lesson_time_id"

  create_table "logos", :force => true do |t|
    t.integer  "organization_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "logos", ["organization_id"], :name => "index_logos_on_organization_id"

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

  create_table "organization_holidays", :force => true do |t|
    t.date     "date"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
  end

  add_index "organization_holidays", ["organization_id"], :name => "index_organization_holidays_on_organization_id"

  create_table "organizations", :force => true do |t|
    t.text     "title"
    t.string   "email"
    t.string   "phone"
    t.string   "site"
    t.string   "subdomain"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "organization_id"
    t.date     "starts_on"
    t.date     "ends_on"
    t.integer  "groups_count"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.boolean  "active",          :default => false
    t.integer  "sum"
  end

  add_index "subscriptions", ["organization_id"], :name => "index_subscriptions_on_organization_id"

  create_table "tariffs", :force => true do |t|
    t.integer  "cost"
    t.integer  "min_group"
    t.integer  "max_group"
    t.integer  "min_month"
    t.integer  "max_month"
    t.integer  "discount_year"
    t.integer  "discount_half_year"
    t.integer  "discount_small"
    t.integer  "discount_medium"
    t.integer  "discount_large"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "timetables", :force => true do |t|
    t.integer  "organization_id"
    t.string   "title"
    t.date     "starts_on"
    t.date     "ends_on"
    t.string   "status"
    t.boolean  "parity"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "first_week_parity"
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
