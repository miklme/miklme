class Resource < ActiveRecord::Base
  has_many :comments
  has_many :commenters,:through => :comments,:source => :user
  belongs_to :owner,:class_name => 'User',:foreign_key => :user_id

  named_scope :search_result,lambda { |keywords|
    { :conditions => ['keywords = ?', keywords],:order => 'created_at DESC' }
  }
  named_scope :by_owner_value, :include => :owner,:order => 'users.value DESC'
  validates_presence_of :keywords,:message => "请填写完全"
  validates_length_of :keywords,:maximum => 139,:message => "内容有点长了。你应该新建长篇内容。",
    :if => :twitter_resource

  before_validation :validates_without_urls

  private
  def validates_without_urls
    if not self.type=="TwitterResource" and  !self.keywords.blank? and self.keywords !~%r{[a-zA-z]+://[^\s]*}
     errors.add(:keywords,"内容包含链接，你应该新建一个链接。")
    end
  end

  def twitter_resource
    self.type="TwitterResource"
  end
  
  def adjust_link_url
    if  !self.link_url=~/http:/ and !self.link_url=~/https:/ and  !self.link_url=~/ftp:/ and  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end

end
