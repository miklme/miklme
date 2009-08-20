class News < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  belongs_to :comment
end
