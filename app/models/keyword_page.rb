class KeywordPage < ActiveRecord::Base
  has_many :related_keywords
  has_many :resources
  validates_uniqueness_of :keyword

end
