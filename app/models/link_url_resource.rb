class LinkUrlResource< Resource 
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  validates_presence_of :description,:message => "写一句简单的描述，请随意"
  validates_presence_of :link_url,:message => "请填写地址"
  validates_inclusion_of :form,:in => %w{ 视频 音频 图片 文字、文档},:message => "请指定目标链接所包含内容的类型"
  validates_format_of :link_url, :with => %r{[a-zA-z]+://[^\s]*},:message => "地址格式不正确，看看是否包含了http://"
end
