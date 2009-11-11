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
      :conditions => "news_type='be_follow' or news_type='be_comment'"

  end

  def self.list_friends_news(user)
    following_ids=user.followings.map do |f|
      f.id
    end
    self.find_all_by_user_id following_ids,
      :order  => "created_at DESC",
      :conditions => "news_type='comment' or news_type='resource'",
      :limit => 32
  end

  def self.self_news_for_others(user,page)
    paginate_by_user_id user.id,
      :per_page => 20,
      :page => page,
      :order => "created_at DESC",
      :conditions => "news_type='comment' or news_type='resource' or news_type='replied_comment'"
  end

  def self.create_comment_news(comment,resource)
    n=resource.owner.news.create
    n.news_type="be_comment"
    n.comment=comment
    n.resource=resource
    n.changed_value=comment.changed_value
    n.save
    n_2=comment.owner.news.create
    n_2.news_type="comment"
    n_2.comment=comment
    n_2.resource=resource
    n_2.save
  end

  def self.create_replied_comment_news(replied_comment,resource)
      n=replied_comment.parent_comment.owner.news.build
      n.news_type="be_comment"
      n.resource=resource
      n.comment=replied_comment
      n.changed_value=replied_comment.changed_value
      n.save
      n_2=replied_comment.owner.news.build
      n_2.news_type="comment"
      n_2.resource=resource
      n_2.comment=replied_comment
      n_2.save
  end
  def self.create_resource_news(resource)
      n=resource.owner.news.create
      n.news_type="resource"
      n.owner=resource.owner
      n.resource=resource
      n.save
  end
end