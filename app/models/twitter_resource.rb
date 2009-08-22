class TwitterResource<Resource
  has_many :replies,:foreign_key => "resource_id"
  has_many :repliers,:through => :replies,:source => :user

  validates_length_of :keywords,:maximum => 130,:message => "内容有点长了。请保持在130字以内。"
  validates_presence_of :keywords,:message => "请填写完全"

end
