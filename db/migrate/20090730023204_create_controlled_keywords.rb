class CreateControlledKeywords < ActiveRecord::Migration
  def self.up
    create_table :controlled_keywords do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :controlled_keywords
  end
end
