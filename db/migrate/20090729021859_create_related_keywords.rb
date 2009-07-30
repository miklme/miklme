class CreateRelatedKeywords < ActiveRecord::Migration
  def self.up
    create_table :related_keywords do |t|
      t.integer :keyword_id
      t.timestamps
    end
  end

  def self.down
    drop_table :related_keywords
  end
end
