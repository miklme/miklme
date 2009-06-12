class CreateImportantDays < ActiveRecord::Migration
  def self.up
    create_table :important_days do |t|
      t.date :day
      t.text :description
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :important_days
  end
end
