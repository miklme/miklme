class TwitterResource<Resource
  has_many :replies,:foreign_key => "resource_id"
  validates_length_of :keywords,:maximum => 139,:message => "内容有点长了。你应该新建长篇内容。"
  validates_presence_of :keywords,:message => "请填写完全"
end
