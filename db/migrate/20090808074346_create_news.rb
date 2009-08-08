class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.integer :owner_id
      t.integer :related_user_id
      t.integer :related_resource_id
      t.integer :related_comment_id
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
