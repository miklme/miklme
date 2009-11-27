class BeFollow < ActiveRecord::Base
  belongs_to :user
  belongs_to :follower,:class_name => "User",:foreign_key => "follower_id"
  validates_uniqueness_of :user_id,:scope => "follower_id",:message => "你已经关注该用户了。"

  after_save :adjust_value
  after_destroy :rechange_value

  private
  def adjust_value
    if self.follower.last_ip!=self.user.last_ip
      self.user.value+=1
      self.user.save
    end
  end

  def rechange_value
    self.user.value-=1
    self.user.save
  end
end
