class ValueOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :keyword_page

  validates_uniqueness_of :keyword_page_id, :scope => "user_id"
end
