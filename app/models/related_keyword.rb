class RelatedKeyword < ActiveRecord::Base
  belongs_to :keyword_page
  validates_uniqueness_of :name,:scope => "keyword_page_id",:message => "不能重复"
end
