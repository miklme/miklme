class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :content
      t.string :title
      t.integer :resource_id
      t.integer :user_id
      t.integer :rating,:default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
