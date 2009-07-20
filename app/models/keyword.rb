class Keyword < ActiveRecord::Base
  has_many :owners,:class_name => "User",:foreign_key => "user_id"
end
