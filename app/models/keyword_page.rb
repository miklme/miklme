require 'rmmseg'
require 'rmmseg/ferret'

class KeywordPage < ActiveRecord::Base
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :keyword => {
          :store => :yes
        },
      },
      :remote => true,
      #  生产环境下别忘记。
      :store_class_name=>true,
      :ferret => {:analyzer => analyzer}
    })
  
  has_many :related_keywords
  has_many :resources
  has_many :value_orders
  has_many :users,:through => :value_orders,:source => :user
  has_one :top_user,:through => :value_orders,:source => :user,:order => "value DESC"
  has_many :users_by_value,:through => :value_orders,:source => :user, :order => "value DESC"

  validates_uniqueness_of :keyword
  validates_presence_of :keyword

  named_scope :user_fields, lambda { |user_id| {
      :include => :value_orders,
      :conditions => [ "value_orders.user_id = ?", user_id ]
    } }
  named_scope :hots,:limit => 15,:include => "users.size DESC"

  def value(user)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(self.id,user.id)
    v.value
  end

  def resources_by_value(page)
    ss=self.resources.sort_by do |resource|
      [self.value_orders.find_by_user_id(resource.owner).value,resource.created_at]
    end
    ss.reverse.paginate(:per_page => 15,:page => page)
  end

  def resources_by_time(page)
    self.resources.paginate(:all,:order => "resources.created_at DESC",:per_page => 15,:page => page)
  end

end
