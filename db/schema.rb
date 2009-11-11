# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091111020943) do

  create_table "addresses", :force => true do |t|
    t.string   "province"
    t.string   "city"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "be_follows", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.boolean  "provide_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "resource_id"
    t.integer  "user_id"
    t.integer  "rating",            :default => 0
    t.integer  "parent_comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "action_one"
    t.string   "action_two"
  end

  create_table "keyword_pages", :force => true do |t|
    t.string   "keyword"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "long_keyword", :default => false
  end

  create_table "news", :force => true do |t|
    t.integer  "user_id"
    t.integer  "resource_id"
    t.integer  "comment_id"
    t.string   "news_type"
    t.integer  "follower_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reply_id"
  end

  create_table "portraits", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "related_keywords", :force => true do |t|
    t.string   "name"
    t.integer  "keyword_page_id"
    t.boolean  "auto",            :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "replies", :force => true do |t|
    t.text     "content"
    t.integer  "resource_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "keywords",        :limit => 50
    t.integer  "user_id"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "keyword_page_id"
  end

  create_table "true_portraits", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 20
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "nick_name",                 :limit => 20
    t.integer  "terms"
    t.date     "birthday"
    t.string   "username",                                :null => false
    t.integer  "mobile_phone"
    t.string   "email"
    t.string   "province"
    t.string   "city"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sex"
    t.string   "last_ip"
    t.integer  "inviter_id"
    t.integer  "inviter_value_order_id"
  end

  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "value_orders", :force => true do |t|
    t.integer "user_id"
    t.integer "keyword_page_id"
    t.decimal "value",           :precision => 20, :scale => 8, :default => 0.0
    t.boolean "hidden",                                         :default => false
    t.boolean "actived",                                        :default => false
  end

end
