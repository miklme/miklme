class AddDescriptionColumnToKeywordPages < ActiveRecord::Migration
  def self.up
    add_column :keyword_pages,:description,:text
  end

  def self.down
    remove_column(:keyword_pages, :description)
  end
end
