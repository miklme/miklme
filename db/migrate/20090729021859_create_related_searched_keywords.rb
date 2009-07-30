class CreateRelatedSearchedKeywords < ActiveRecord::Migration
  def self.up
    create_table :related_searched_keywords do |t|
      t.integer :searched_keyword_id
      t.timestamps
    end
  end

  def self.down
    drop_table :related_searched_keywords
  end
end
