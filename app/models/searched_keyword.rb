class SearchedKeyword < ActiveRecord::Base
  belongs_to :searcher,:class_name => "User",:foreign_key => 'user_id'
  has_many :related_searched_keywords,:class_name => "SearchedKeyword",:foreign_key => "related_searched_keyword_id"

end
