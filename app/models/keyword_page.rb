class KeywordPage < ActiveRecord::Base
  has_many :related_keywords
  validates_uniqueness_of :keyword

end
