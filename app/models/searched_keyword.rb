class SearchedKeyword < ActiveRecord::Base
  belongs_to :searcher,:class_name => "User",:foreign_key => 'user_id'
  has_many :related_keywords,:limit => 10
end
