class CreatePortraits < ActiveRecord::Migration
  def self.up
    create_table :portraits do |t|
      t.integer :user_id
      t.string :image_file
      
      t.timestamps
    end
  end

  def self.down
    drop_table :portraits
  end
end
