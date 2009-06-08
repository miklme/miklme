class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :name, :limit => 20, :default => '', :null => true
      t.string :email, :limit => 100,:null => false
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.string :activation_code, :limit => 40
      t.datetime :activated_at
      t.string :nick_name,:limit=>20,:uniq => true
      t.string :province
      t.string :city
      t.integer :value,:default=>0

      t.timestamps

    end
    add_index :users, :email, :uniq => true
  end

  def self.down
    drop_table :users
  end
end
