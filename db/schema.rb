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

ActiveRecord::Schema.define(:version => 20090612035415) do

  create_table "friendships", :force => true do |t|
    t.integer  "user_id",                                                                      :null => false
    t.integer  "friend_id",                                                                    :null => false
    t.integer  "friendship_value", :limit => 10, :precision => 10, :scale => 0, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "friendships", ["user_id", "friend_id"], :name => "index_friendships_on_user_id_and_friend_id"

  create_table "important_days", :force => true do |t|
    t.date     "day"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "markings", :force => true do |t|
    t.text     "comment"
    t.string   "title"
    t.integer  "resource_id"
    t.integer  "user_id"
    t.integer  "rating",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "portraits", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "link_url"
    t.text     "content"
    t.boolean  "shoulu",                   :default => true
    t.integer  "user_id"
    t.integer  "value"
    t.string   "keywords",   :limit => 23
    t.string   "addition",   :limit => 14
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "true_portraits", :force => true do |t|
    t.integer  "user_id"
    t.string   "image_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                      :limit => 20,                                 :default => ""
    t.string   "email",                     :limit => 100,                                                 :null => false
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "nick_name",                 :limit => 20
    t.string   "state"
    t.string   "city"
    t.integer  "follower_id"
    t.decimal  "value",                                    :precision => 8,  :scale => 1, :default => 0.0
    t.integer  "money",                     :limit => 10,  :precision => 10, :scale => 0, :default => 10
    t.integer  "terms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
