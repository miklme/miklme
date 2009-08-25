class Resource < ActiveRecord::Base
  belongs_to :keyword_page
  belongs_to :owner,:class_name => 'User',:foreign_key =>"user_id"
  named_scope :by_owner_value, :include => :owner,:order => 'users.value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :in_one_day,:conditions => ["created_at > ?",Time.now.yesterday]

  private
  def adjust_link_url
    if  !self.link_url=~/http:/ and !self.link_url=~/https:/ and  !self.link_url=~/ftp:/ and  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end

end
