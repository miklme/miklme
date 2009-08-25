class News < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  belongs_to :comment
  default_scope  :order => "created_at DESC"

  def follower
    User.find(self.follower_id)
  end
end
