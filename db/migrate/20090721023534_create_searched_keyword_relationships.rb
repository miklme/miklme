class CreateSearchedKeywordRelationships < ActiveRecord::Migration
  def self.up
    create_table :searched_keyword_relationships do |t|
      t.integer :searched_keyword_id,:null => false
      t.integer :related_searched_keyword_id,:null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :searched_keyword_relationships
  end
end
