class Comment < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => "user_id"
  belongs_to :resource
  has_many :replied_comments,:class_name => "Comment",:foreign_key => "parent_comment_id"
  has_many :news,:dependent => :destroy
  belongs_to :parent_comment,:class_name => "Comment",:foreign_key => "parent_comment_id"

  named_scope :by_owner_value, :include => :owner,:order => 'users.total_value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :recent_comments,:limit => 3,:order => 'created_at DESC'
  named_scope :parent_comments,:conditions => "parent_comment_id is NULL"
  validates_presence_of :content

  after_create :adjust_resource_updated_at

  private

  def adjust_resource_updated_at
    self.resource.updated_at=Time.now
    self.resource.save
  end
  
end
