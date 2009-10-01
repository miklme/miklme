class AddColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:inviter_id,:integer
    add_column :users,:inviter_value_order_id,:integer
  end

  def self.down
    remove_column(:users,:inviter_id,:inviter_value_order_id)
  end
end
