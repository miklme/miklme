class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.integer :user_id
      t.integer :resource_id
      t.integer :comment_id
      t.string :news_type
      t.integer :follower_id
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
