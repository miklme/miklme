class ChangeValueColumnScale < ActiveRecord::Migration
  def self.up
    change_column :value_orders,:value,:decimal,:default=>0,:precision => 8,:scale => 2
  end

  def self.down
  end
end
