class News < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  belongs_to :comment
  belongs_to :reply
  default_scope  :order => "created_at DESC"

  def follower
    User.find(self.follower_id)
  end

  def self.list_self_news(current_user,page)
    paginate :per_page => 15,
      :page => page,
      :order => "created_at DESC",
      :conditions => ["user_id=?",current_user.id]
  end

  def self.list_others_news(user,page)
    following_ids=user.followings.map do |f|
      f.id
    end
    self.paginate_by_user_id following_ids,
      :per_page => 15,
      :page => page,
      :order  => "created_at DESC",
      :conditions => "news_type='twitter_resource' or news_type='link_url_resource' or news_type='blog_resource'"
  end

  def self.self_news_for_others(user,page)
    paginate_by_user_id user.id,
      :per_page => 20,
      :page => page,
      :order => "created_at DESC",
      :conditions => "news_type='twitter_resource' or news_type='link_url_resource' or news_type='blog_resource'"
  end

end