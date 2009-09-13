class ChangeResourceKeywordsLimit < ActiveRecord::Migration
  def self.up
    change_column :resources,:keywords,:string,:limit => 50
  end

  def self.down
  end
end
