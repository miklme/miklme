class CreateSearchedKeywords < ActiveRecord::Migration
  def self.up
    create_table :searched_keywords do |t|
      t.integer :searched_times,:default => 1
      t.string :name
      t.integer :user_id
      t.integer :related_searched_keyword_id
      t.timestamps
    end
  end

  def self.down
    drop_table :searched_keywords
  end
end
