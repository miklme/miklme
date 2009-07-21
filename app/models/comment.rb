class Comment < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => :user_id
  belongs_to :resource

  named_scope :good_comments,:limit => 3,:order => 'created_at DESC'
end
