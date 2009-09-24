class AddSexColumnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:sex,:integer
  end

  def self.down
    remove_column(:users, :sex)
  end
end
