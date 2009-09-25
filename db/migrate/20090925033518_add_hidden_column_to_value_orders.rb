class AddHiddenColumnToValueOrders < ActiveRecord::Migration
  def self.up
    add_column :value_orders,:hidden,:boolean,:default => false
  end

  def self.down
    remove_column(:value_orders, :hidden)
  end
end
