class SearchedKeyword < ActiveRecord::Base
  belongs_to :users
  validates_uniqueness_of :name,:scope => "user_id"
end
