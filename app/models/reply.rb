class Reply < ActiveRecord::Base
  belongs_to :owner,:class_name => "User",:foreign_key => :user_id
  belongs_to :resource

  default_scope :order => "created_at"
  validates_presence_of :content
end
