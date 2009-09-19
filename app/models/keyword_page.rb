require 'rmmseg'
require 'rmmseg/ferret'

class KeywordPage < ActiveRecord::Base
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :keyword => {
          :store => :yes
        },
        :created_at_s=>{:index=>:untokenized,:store=>:yes},
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

  validates_uniqueness_of :keyword
  validates_presence_of :keyword

  named_scope :user_fields, lambda { |user_id| {
      :include => :value_orders,
      :conditions => [ "value_orders.user_id = ?", user_id ]
    } }


  def value(user)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(self.id,user.id)
    v.value
  end

  def top_owner
    users=self.users
    users.find(:first,:order => "value_orders.value")
  end

end
