class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :keywords,:limit => 20
      t.string :type
      t.boolean :shoulu,:default => true
      t.integer :user_id
      #blog_resources
      t.string :title
      #attributes for link_url resources
      t.string :form
      t.string :link_url
      t.string :description
      t.boolean :authority,:default => false
      #attributes for twitter_resources
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
