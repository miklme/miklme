class AddChangedValueToNews < ActiveRecord::Migration
  def self.up
    add_column :news,:changed_value,:decimal,:precision => 10,:scale => 2
    add_column :news,:attitude,:integer
  end

  def self.down
    remove_column(:news, :changed_value,:attitude)
  end
end
