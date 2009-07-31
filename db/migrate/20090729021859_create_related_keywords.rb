class CreateRelatedKeywords < ActiveRecord::Migration
  def self.up
    create_table :related_keywords do |t|
      t.string :name
      t.integer :keyword_page_id
      t.boolean :auto,:default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :related_keywords
  end
end
