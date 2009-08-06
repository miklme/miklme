class Follow < ActiveRecord::Base
  belongs_to :following,:class_name => "User",:foreign_key => "following_id"
  belongs_to :user
end
