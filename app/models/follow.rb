class Follow < ActiveRecord::Base
  belongs_to :user
  belongs_to :followings,:class_name => "User",:foreign_key => :following_id
end
