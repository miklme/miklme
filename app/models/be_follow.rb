class BeFollow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower,:class_name => "User",:foreign_key => "follower_id"
  named_scope :real_friends,:conditions => {:provide_name => true}
end
