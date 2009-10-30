class RemoveColumnsFromResources < ActiveRecord::Migration
  def self.up
    remove_column(:resources, :form,:link_url,:description,:shoulu,:authority)
  end

  def self.down
  end
end
