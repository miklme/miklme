require 'rmmseg'
require 'rmmseg/ferret'

class Resource < ActiveRecord::Base

  belongs_to :owner,:class_name => 'User',:foreign_key =>"user_id"
  default_scope :include => :owner,:order => 'users.value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :in_one_day,:conditions => ["resources.created_at > ?",Time.now.yesterday]
  named_scope :by_owner_value,:include => :owner,:order => 'users.value DESC'
  
    def created_at_s
    created_at.advance(:hours => 8).to_s(:db)
  end
  def updated_at_s
    updated_at.advance(:hours => 8).to_s(:db)
  end

  private
  def adjust_link_url
    if  !self.link_url=~/http:/ and !self.link_url=~/https:/ and  !self.link_url=~/ftp:/ and  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end


end
