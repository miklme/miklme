class SearchedKeyword < ActiveRecord::Base
  belongs_to :searcher,:class_name => "User",:foreign_key => 'user_id'
  has_many :searched_keyword_relationships
  has_many :related_searched_keywords,:limit => 10,
    :through => :searched_keyword_relationships,
    :source => :searched_keyword,
    :class_name => "SearchedKeyword"


end
