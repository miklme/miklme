class AddLongKeywordColumnToKeywordPages < ActiveRecord::Migration
  def self.up
    add_column :keyword_pages,:long_keyword,:boolean,:default => false
  end

  def self.down
    remove_column(:keyword_pages, :long_keyword)
  end
end
