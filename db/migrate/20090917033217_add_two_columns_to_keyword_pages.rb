class AddTwoColumnsToKeywordPages < ActiveRecord::Migration
  def self.up
    add_column :keyword_pages,:user_id,:integer
    add_column :keyword_pages,:value,:decimal,:default=>0,:precision => 8,:scale => 1

  end

  def self.down
    remove_column(:keyword_pages, :user_id)
    remove_column(:keyword_pages, :value)
  end
end
