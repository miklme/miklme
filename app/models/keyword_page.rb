class KeywordPage < ActiveRecord::Base
  has_many :related_keywords
  validates_uniqueness_of :keyword

  def can_be_top_owner?(user)
    resources=Resource.find_all_by_keywords(self.keyword)
    user_ids=resources.map do |r|
      r.owner.id
    end
    if User.find(user_ids,:order => "value DESC").first.value<=user.value and !User.find(user_ids).include?(user)
      true
    else
      false
    end
  end
end
