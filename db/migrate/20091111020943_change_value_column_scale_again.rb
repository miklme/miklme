class ChangeValueColumnScaleAgain < ActiveRecord::Migration
  def self.up
    change_column :value_orders,:value,:decimal,:default=>0,:precision => 20,:scale => 8
  end

  def self.down
  end
end
