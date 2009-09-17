class AddKeywordPageIdToResource < ActiveRecord::Migration
  def self.up
    add_column :resources,:keyword_page_id,:integer
  end

  def self.down
    remove_column(:resources, :keyword_page_id)
  end
end
