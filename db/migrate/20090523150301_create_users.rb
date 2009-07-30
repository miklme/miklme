class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :name, :limit => 20
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.string :nick_name,:limit=>20
      t.integer :follower_id
      t.integer :following_id
      t.decimal  :value,:default=>0,:precision => 8,:scale => 1
      t.integer :terms
      t.date :birthday
      t.string :username,:null => false
      t.integer :failed_signin_times

      t.timestamps

    end
    add_index :users, :username, :uniq => true
  end

  def self.down
    drop_table :users
  end
end
