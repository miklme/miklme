class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :link_url
      t.text :content
      t.string :title
      t.boolean :shoulu
      t.integer :user_id
      t.integer :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
