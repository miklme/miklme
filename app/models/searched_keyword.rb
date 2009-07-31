class SearchedKeyword < ActiveRecord::Base
  has_and_belongs_to_many :users
  validates_uniqueness_of :name,:scope => "user_id"
end
