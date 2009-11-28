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
  has_one :top_user,:through => :value_orders,:source => :user,:order => "users.value DESC"
  validates_uniqueness_of :keyword,:message => "这个关键字已经存在了"
  validates_presence_of :keyword,:message => "关键字名不能为空"
  named_scope :user_fields, lambda { |user_id| {
      :include => :value_orders,
      :conditions => [ "value_orders.user_id = ?", user_id ]
    } }
  named_scope :hots,:limit => 10,:order => "users.size DESC"

 
  def good_resource
    active_members=User.find(:all,:conditions => "value>0")
    authors=self.users_have_resources
    users=(active_members&authors)
    recent_resources=users.map do |u|
      u.resources.find(:all,:order => "resources.created_at DESC",:conditions => {:keyword_page_id => self.id})
    end
    results=recent_resources.flatten.sort_by { |r| r.created_at }.reverse.first
  end

  def users_have_resources
    ids=self.resources.map do |r|
      r.user_id
    end
    ids=ids.uniq
    users=User.find_all_by_id(ids)
    ordered=users.sort_by { |u| [u.value,u.created_at]}.reverse
  end
  def self.recent_keyword_pages
    a=self.find(:all,:order => "created_at DESC",:limit => 10)
  end

  def self.active_user_keyword_pages
    keyword_pages=self.find(:all,:limit => 5,:include => :resources,:conditions => "resources.keyword_page_id is not NULL",:order => "keyword_pages.updated_at DESC")
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
    pages.reverse.first(10)
  end
  
end
