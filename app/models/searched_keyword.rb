class SearchedKeyword < ActiveRecord::Base
  belongs_to :user
  has_many :related_keywords,:class_name => "SearchedKeyword",:foreign_key => "related_keyword_id"
end
