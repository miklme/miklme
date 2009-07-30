class SearchedKeyword < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :related_keywords,:limit => 10
  validates_uniqueness_of :name
end
