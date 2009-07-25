class TwitterResource<Resource
#  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
#  validates_presence_of :keywords,:message => "请填写完全"
#  validates_length_of :keywords,:maximum => 139,:message => "内容有点长了。你应该新建长篇内容。"
#
#  before_save :validates_without_urls
#
#  private
#  def validates_without_urls
#    self.keywords !~%r{[a-zA-z]+://[^\s]*}
#  end
end
