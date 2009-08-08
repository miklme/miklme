class Comment < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => :user_id
  belongs_to :resource

  named_scope :by_owner_value, :include => :owner,:order => 'users.value DESC'
  named_scope :good_comments,:limit => 3, :include => :owner,:order => 'users.value DESC'
end
