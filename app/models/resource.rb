class Resource < ActiveRecord::Base
  has_many :comments
  has_many :commenters,:through => :comments,:source => :user
  belongs_to :owner,:class_name => 'User',:foreign_key => :user_id
  validates_presence_of :link_url,:message => '链接不能为空',:if => :validates_outer_resource

  named_scope :search_result,lambda { |keywords|
    { :conditions => ['keywords = ?', keywords],:order => 'created_at DESC' }
  }
  named_scope :by_owner_value, :include => :owner,:order => 'users.value DESC'
  before_save :adjust_link_url
  
  private
  def adjust_link_url
    if  !self.link_url=~/http:/ or !self.link_url=~/https:/ or  !self.link_url=~/ftp:/ or  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end

  def validates_outer_resource
    if self.link_url?
      true
    else
      false
    end
  end
end
