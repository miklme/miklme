class SearchedKeywordRelationship < ActiveRecord::Base
  belongs_to :searched_keyword
  belongs_to :related_searched_keyword,
    :class_name => "SearchedKeyword",
    :foreign_key => :related_searched_keyword_id
  end
