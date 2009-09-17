class ValueOrder < ActiveRecord::Base
  belongs_to :user
  belongs_to :keyword_page

  validates_uniqueness_of :keyword_page_id, :scope => "user_id"

  def self.order(user,keyword_page)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(keyword_page.id,user.id)
    vs=ValueOrder.find_all_by_keyword_page_id(keyword_page.id,:conditions => ["value >= ?",v.value])
    vs.size
  end
end
