class CreateKeywordsControllings < ActiveRecord::Migration
  def self.up
    create_table :keywords_controllings do |t|
      t.integer :user_id
      t.integer :controlled_keyword_id
      t.timestamps
    end
  end

  def self.down
    drop_table :keywords_controllings
  end
end
