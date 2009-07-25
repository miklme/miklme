class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :province
      t.string :city
t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
