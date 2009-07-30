class CreateRelatedKeywords < ActiveRecord::Migration
  def self.up
    create_table :related_keywords do |t|
      t.string :name
      t.integer :searched_keyword_id
      t.timestamps
    end
  end

  def self.down
    drop_table :related_keywords
  end
end
