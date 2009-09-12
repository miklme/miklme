class AddReplyIdColumnToNews < ActiveRecord::Migration
  def self.up
    add_column :news,:reply_id,:integer
  end

  def self.down
    remove_column(:news, :reply_id)
  end
end
