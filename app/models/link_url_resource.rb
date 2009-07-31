class LinkUrlResource< Resource 
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  validates_presence_of :keywords,:message => "不要放弃机会..."
  validates_presence_of :description,:message => "请随意"
  validates_presence_of :link_url,:message => "必填"
  validates_inclusion_of :form,:in => %w{视频 音频 图片 文字、文档},:message => "请指定目标链接所包含内容的类型"
  validates_format_of :link_url, :with => %r{[a-zA-z]+://[^\s]*},:message => "看看是否包含了http://"
end
