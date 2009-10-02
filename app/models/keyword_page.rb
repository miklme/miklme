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
  has_many :blog_resources,:conditions => "type=BlogResource"
  has_many :link_url_resources,:conditions => "type=LinkUrlResource"
  has_many :value_orders
  has_many :users,:through => :value_orders,:source => :user
  has_one :top_user,:through => :value_orders,:source => :user,:order => "value DESC"
  has_many :users_by_value,:through => :value_orders,:source => :user, :order => "value DESC"

  validates_uniqueness_of :keyword
  validates_presence_of :keyword
  validates_length_of :keyword, :maximum => 50
  named_scope :user_fields, lambda { |user_id| {
      :include => :value_orders,
      :conditions => [ "value_orders.user_id = ?", user_id ]
    } }
  named_scope :hots,:limit => 10,:order => "users.size DESC"
  
  def field_value(user)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(self.id,user.id)
    v.value
  end

  def comment_value(current_user)
    current_user.field_value(self)/10+0.5
  end
  
  def resources_by_value(page)
    ss=self.resources.sort_by do |resource|
      [self.value_orders.find_by_user_id(resource.owner).value,resource.created_at]
    end
    ss.reverse.paginate(:per_page => 15,:page => page)
  end

  def top_resource
    ss=self.resources.sort_by do |resource|
      [self.value_orders.find_by_user_id(resource.owner).value,resource.created_at]
    end
    ss.reverse.first
  end
  
  def resources_by_time(page)
    self.resources.paginate(:all,:order => "resources.updated_at DESC",:per_page => 15,:page => page)
  end

  def self.hot_keyword_pages
    a=self.find(:all).sort_by { |k| k.users.size }
    a.reverse.first(15)
  end

  def self.long_name_keyword_pages
    a=self.find(:all).sort_by {|k| k.keyword.length}
    a.reverse.first(15)
  end

  def self.girls_pages
    pages=self.find(:all).map do |k|
      girls_amount=k.users.find(:all,:conditions => "sex=0").size
      total_amount=k.users.find(:all).size+1
      if (girls_amount/total_amount)>0.7
        k
      else
        nil
      end
    end
    pages=pages.compact.sort_by {|p| p.users.size}
    pages.reverse
  end
end
