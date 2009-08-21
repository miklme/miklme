class BeFollow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower,:class_name => "User",:foreign_key => "follower_id"
  named_scope :real_friends,:conditions => {:provide_name => true}
  validates_uniqueness_of :user_id,:scope => "follower_id",:message => "你已经关注该用户了。"
end
