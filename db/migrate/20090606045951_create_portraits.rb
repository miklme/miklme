class CreatePortraits < ActiveRecord::Migration
  def self.up
    create_table :portraits do |t|
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :portraits
  end
end
