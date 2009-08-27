class Comment < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  has_many :replied_comments,:class_name => "Comment",:foreign_key => "parent_comment_id"
  belongs_to :parent_comment,:class_name => "Comment",:foreign_key => "parent_comment_id"

  named_scope :by_owner_value, :include => :owner,:order => 'users.value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :good_comments,:limit => 3, :include => :owner,:order => 'users.value DESC'
  named_scope :parent_comments,:conditions => "parent_comment_id is NULL"
  validates_presence_of :content

  def self.find_parent_comments(resource,page)
    paginate :page => page,
      :per_page => 10,
      :conditions => ["resource_id=? and parent_comment_id is NULL",resource.id],
      :include => :owner,
      :order => 'users.value DESC'
  end

  def self.find_parent_comments_by_time(resource,page)
    paginate :page => page,
      :per_page => 10,
      :conditions => ["resource_id=? and parent_comment_id is NULL",resource.id],
      :order => "comments.created_at DESC"
    end
end
