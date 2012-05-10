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

ActiveRecord::Schema.define(:version => 20120510230745) do

  create_table "orders", :force => true do |t|
    t.integer  "order_id"
    t.integer  "purchase_id"
    t.float    "ticket_revenue"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "order_date"
    t.string   "order_type_name"
    t.string   "event_category"
    t.string   "event_name"
    t.datetime "event_date"
    t.integer  "tickets"
    t.integer  "order_year"
  end

  add_index "orders", ["order_date"], :name => "index_orders_on_order_date"
  add_index "orders", ["order_id"], :name => "index_orders_on_order_id"

  create_table "revenue_reports", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "updates", :force => true do |t|
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "update_type"
  end

  add_index "updates", ["created_at"], :name => "index_updates_on_created_at"
  add_index "updates", ["update_type"], :name => "index_updates_on_update_type"

  create_table "visits", :force => true do |t|
    t.date     "date"
    t.string   "medium"
    t.integer  "visits"
    t.integer  "orders"
    t.float    "revenue"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "brand"
    t.integer  "year"
  end

  add_index "visits", ["date"], :name => "index_visits_on_date"

end
