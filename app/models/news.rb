class News < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  belongs_to :comment
  default_scope  :order => "created_at DESC"

  after_save :check_repeat
  def follower
    User.find(self.follower_id)
  end

  def self.list_self_news(current_user,page)
    paginate :per_page => 15,
      :page => page,
      :order => "created_at DESC",
      :conditions => ["user_id=?",current_user.id]
  end

  def check_repeat
    if News.find(:all,:conditions => self).count>=2
      News.find(:last,:conditions => self,:order => "news.created_at DESC").destroy
    end
  end

end
