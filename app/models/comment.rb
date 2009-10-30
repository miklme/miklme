class Comment < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  has_many :comments,:class_name => "Comment",:foreign_key => "parent_comment_id"
  has_many :commenters,:through => :comments,:source => :owner
  has_many :good_commenters,:through => :comments,:source => :owner,:conditions => "rating>0"
  has_many :bad_commenters,:through => :comments,:source => :owner,:conditions => "rating<0"
  has_many :news,:dependent => :destroy
  belongs_to :parent_comment,:class_name => "Comment",:foreign_key => "parent_comment_id"

  named_scope :by_owner_value, :include => :owner,:order => 'users.total_value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :recent_comments,:limit => 3,:order => 'comments.created_at DESC'
  named_scope :parent_comments,:conditions => "parent_comment_id is NULL"
  validates_presence_of :content

  after_create :adjust_resource_updated_at

  def parent
    if self.parent_comment.present?
      self.parent_comment
    else
      self.resource
    end
  end

  private
  def adjust_resource_updated_at
    self.resource.updated_at=Time.now
    self.resource.save
  end

  
end
