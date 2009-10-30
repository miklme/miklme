class News < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  belongs_to :comment
  belongs_to :reply
  default_scope  :order => "created_at DESC"

  def follower
    User.find(self.follower_id)
  end

  def self.list_self_news(current_user)
    find_all_by_user_id current_user.id,
      :order => "created_at DESC",
      :limit => 10,
      :conditions => "news_type='be_follow' or news_type='be_comment' or news_type='be_replied_comment'"

  end

  def self.list_friends_news(user)
    following_ids=user.followings.map do |f|
      f.id
    end
    self.find_all_by_user_id following_ids,
      :order  => "created_at DESC",
      :conditions => "news_type='comment' or news_type='blog_resource' or news_type='replied_comment'",
      :limit => 32
  end

  def self.self_news_for_others(user,page)
    paginate_by_user_id user.id,
      :per_page => 20,
      :page => page,
      :order => "created_at DESC",
      :conditions => "news_type='comment' or news_type='blog_resource' or news_type='replied_comment'"
  end

end