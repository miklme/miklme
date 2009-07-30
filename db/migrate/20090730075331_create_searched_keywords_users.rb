class CreateSearchedKeywordsUsers < ActiveRecord::Migration
  def self.up
    create_table :searched_keywords_users do |t|
      t.integer :user_id
      t.integer :searched_keyword_id
    end
  end

  def self.down
    drop_table :searched_keywords_users
  end
end
