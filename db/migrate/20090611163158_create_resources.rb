class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      #common attributes
      t.string :type
      t.boolean :shoulu,:default => true
      t.integer :user_id
      t.string :keywords,:limit => 23
      t.string :title,:limit => 14
      t.integer :order
      #attributes for outer resources
      t.string :link_url


      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
