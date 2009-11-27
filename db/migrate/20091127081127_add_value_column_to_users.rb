class AddValueColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:value,:decimal,:default=>0,:precision => 20,:scale => 8
    User.find(:all).map do |u|
      u.value=u.total_value
      u.save
    end
  end

  def self.down
    remove_column :users,:value
  end
end
