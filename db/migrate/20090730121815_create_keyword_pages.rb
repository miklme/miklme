class CreateKeywordPages < ActiveRecord::Migration
  def self.up
    create_table :keyword_pages do |t|
      t.string :keyword
      t.integer :resource_id
      t.timestamps
    end
  end

  def self.down
    drop_table :keyword_pages
  end
end
