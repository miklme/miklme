class CreateReplies < ActiveRecord::Migration
  def self.up
    create_table :replies do |t|
      t.text :content
      t.integer :resource_id
      t.integer :user_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :replies
  end
end
