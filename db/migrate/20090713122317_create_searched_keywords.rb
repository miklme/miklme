class CreateSearchedKeywords < ActiveRecord::Migration
  def self.up
    create_table :searched_keywords do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :searched_keywords
  end
end
