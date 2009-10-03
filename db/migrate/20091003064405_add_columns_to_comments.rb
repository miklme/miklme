class AddColumnsToComments < ActiveRecord::Migration
  def self.up
    add_column :comments,:action_one,:string
    add_column :comments,:action_two,:string
  end

  def self.down
    remove_column :comments,:action_one,:action_two
  end
end
