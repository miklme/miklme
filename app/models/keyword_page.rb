class KeywordPage < ActiveRecord::Base
  has_many :related_keywords
  belongs_to :resource
  validates_uniqueness_of :keyword
end
