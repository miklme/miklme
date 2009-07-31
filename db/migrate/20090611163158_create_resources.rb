class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :keyword_page_id
      t.string :keywords,:limit => 139,:null => false
      t.string :type
      t.boolean :shoulu,:default => true
      t.integer :user_id
      #blog_resources
      t.text :content
      t.string :title
      #attributes for link_url resources
      t.string :form
      t.string :link_url
      t.string :description
      t.boolean :authority,:default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
