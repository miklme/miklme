class BlogResource<Resource 
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
end