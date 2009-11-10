class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :keywords,:limit => 20
      t.string :type
      t.boolean :shoulu,:default => true
      t.integer :user_id
      t.string :title
      t.string :form
      t.string :link_url
      t.string :description
      t.boolean :authority,:default => false
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
