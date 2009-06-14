class CreateTaggings < ActiveRecord::Migration
  def self.up
    create_table :taggings do |t|
      t.integer :resource_id
      t.integer :tag_id
      t.boolean :style_tag,:default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :taggings
  end
end
