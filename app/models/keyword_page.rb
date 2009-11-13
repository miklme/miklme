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
  has_many :active_users,:through => :value_orders,:source => :user,:conditions => "value > 0"
  validates_uniqueness_of :keyword,:message => "这个贴吧已经存在了"
  validates_presence_of :keyword,:message => "贴吧名不能为空"
  validates_length_of :keyword,:within => 1..20
  named_scope :user_fields, lambda { |user_id| {
      :include => :value_orders,
      :conditions => [ "value_orders.user_id = ?", user_id ]
    } }
  named_scope :hots,:limit => 10,:order => "users.size DESC"

  def field_value(user)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(self.id,user.id)
    if v.present?
      v.value
    else
      0.0
    end
  end
  
  def good_comment(user1,user2)
    ((user1.field_value(self)-user2.field_value(self))/2).abs
  end

  def bad_comment(user1,user2)
    (user1.field_value(self)-user2.field_value(self)).abs
  end
  
  def resources_by_value
    ss=self.resources.sort_by do |resource|
      [self.value_orders.find_by_user_id(resource.owner).value,resource.created_at]
    end
    ss.reverse
  end
  def top_resource
    ss=self.resources.sort_by do |resource|
      [self.value_orders.find_by_user_id(resource.owner).value,resource.created_at]
    end
    ss.reverse.first
  end
  
  def resources_by_time(page)
    self.resources.paginate(:all,:order => "resources.created_at DESC",:per_page => 10,:page => page)
  end

  def good_resources
    active_members=self.active_users
    authors=self.users_have_resources
    users=(active_members&authors)
    recent_resources=users.map do |u|
      u.resources.find(:all,:order => "resources.created_at DESC",:conditions => {:keyword_page_id => self.id})
    end
    results=recent_resources.flatten.sort_by { |r| r.created_at }.reverse.first(3)
  end

  def users_have_resources
    ids=self.resources.map do |r|
      r.user_id
    end
    ids=ids.uniq
    users=User.find_all_by_id(ids)
    ordered=users.sort_by { |u| [u.field_value(self),u.created_at]}.reverse
  end
  def self.recent_keyword_pages
    a=self.find(:all,:order => "created_at DESC",:limit => 10)
  end

  def self.active_user_keyword_pages
    keyword_pages=self.find(:all).find_all{|k| k.active_users.size>=1}.sort_by {|k| k.updated_at}.reverse
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
