class LinkUrlResource< Resource
  has_many :comments,:foreign_key => "resource_id"
  has_many :commenters,:through => :comments,:source => :user
  validates_inclusion_of :form,:in => %w{视频 音频 图片 文字、文档},:message => "请指定目标链接所包含内容的类型"
  validates_format_of :link_url, :with => %r{[a-zA-z]+://[^\s]*},:message => "看看是否包含了http://"
  validates_length_of :description,:within => 1..30
  validates_length_of :link_url,:maximum => 1000
  named_scope :hot_resources,:include => :comments,:condition => "comments.size>10"


end
