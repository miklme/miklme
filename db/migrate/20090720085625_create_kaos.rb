class CreateKaos < ActiveRecord::Migration
  def self.up
    create_table :kaos do |t|
      t.integer :user_id
      t.integer :keyword_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :kaos
  end
end
