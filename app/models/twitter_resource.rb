class TwitterResource<Resource
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  validates_length_of :keywords,:maximum => 139,:message => "内容有点长了。你应该新建长篇内容。"
  validates_presence_of :keywords,:message => "请填写完全"
end
