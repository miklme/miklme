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


  def can_be_top_owner?(user)
    resources=Resource.find_all_by_keywords(self.keyword)
    user_ids=resources.map do |r|
      r.owner.id
    end
    users=User.find(user_ids,:order => "value DESC")
    if users.present?
      if  users.first.value<=user.value and !User.find(user_ids).include?(user)
        true
      else
        false
      end
    else
      false
    end
  end

  def value(user)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(self.id,user.id)
    v.value
  end
end
