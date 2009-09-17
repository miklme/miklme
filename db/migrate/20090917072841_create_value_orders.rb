class CreateValueOrders < ActiveRecord::Migration
  def self.up
    create_table :value_orders do |t|
      t.integer :user_id
      t.integer :keyword_page_id
      t.decimal :value,:default=>0,:precision => 8,:scale => 1
    end
  end

  def self.down
        drop_table :value_orders
  end
end
