class RemoveValueFromUsers < ActiveRecord::Migration
  def self.up
    remove_column(:users, :value)
  end

  def self.down
    add_column :users,:value,:decimal,:default=>0,:precision => 8,:scale => 1
  end
end
