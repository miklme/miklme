class KeywordPage < ActiveRecord::Base
  has_many :related_keywords
  has_many :resources
  belongs_to :user
  validates_uniqueness_of :keyword,:scope => :user_id,:message => "领域名称重复了"

  def can_be_top_owner?(user)
    resources=Resource.find_all_by_keywords(self.keyword)
    user_ids=resources.map do |r|
      r.owner.id
    end
    users=User.find(user_ids,:order => "value DESC")
    if users.present?
      if  users.first.value<=user.value and !User.find(user_ids).include?(user)
        true
      else
        false
      end
    else
      false
    end
  end
end
