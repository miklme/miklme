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
  has_many :blog_resources
  has_many :value_orders
  has_many :users,:through => :value_orders,:source => :user
  has_one :top_user,:through => :value_orders,:source => :user,:order => "value DESC"
  has_many :users_by_value,:through => :value_orders,:source => :user, :order => "value DESC,created_at DESC"
  has_many :active_users,:through => :value_orders,:source => :user,:conditions => "value > 0"
  validates_uniqueness_of :keyword,:message => "这个关键字已经存在了"
  validates_presence_of :keyword,:message => "关键字名不能为空"
  validates_length_of :keyword, :maximum => 8,:if => Proc.new {|k| !k.long_keyword},:message => "名称长度不符合要求"
  named_scope :user_fields, lambda { |user_id| {
      :include => :value_orders,
      :conditions => [ "value_orders.user_id = ?", user_id ]
    } }
  named_scope :hots,:limit => 10,:order => "users.size DESC"
  
  def field_value(user)
    v=ValueOrder.find_by_keyword_page_id_and_user_id(self.id,user.id)
    v.value
  end

  def higher_lower_good(user1,user2)
    (user1.field_value(self)-user2.field_value(self))/2
  end

  def lower_higher_good(r)
    s=r.good_commenters.size
    0.15*(s**2-(s-1)**2)
  end

  def lower_higher_bad(r)
    b=r.bad_commenters.size
    0.15*(b**2-(b-1)**2)
  end

  def higher_lower_bad(user)
    (user.field_value(self)/3).abs
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

def self.recent_keyword_pages
  a=self.find(:all,:order => "updated_at DESC",:limit => 10)
end

def self.many_resources_keyword_pages
  a=self.find(:all).sort_by {|k| k.resources.size}
  a.reverse.first(10)
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
