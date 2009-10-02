class AddActivedColumnToValueOrders < ActiveRecord::Migration
  def self.up
    add_column :value_orders,:actived,:boolean,:default => false
  end

  def self.down
    remove_column(:value_orders, :actived)
  end
end
