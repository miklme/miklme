class RemoveTypeFromResource < ActiveRecord::Migration
  def self.up
    remove_column(:resources, :type)
  end

  def self.down
  end
end
