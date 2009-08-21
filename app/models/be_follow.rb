class BeFollow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower,:class_name => "User",:foreign_key => "follower_id"
  validates_uniqueness_of :user_id,:scope => "follower_id",:message => "你已经关注该用户了。"
end
