class CreateBeFollows < ActiveRecord::Migration
  def self.up
    create_table :be_follows do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :be_follows
  end
end
