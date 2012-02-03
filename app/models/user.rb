require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  attr_accessor :password_confirmation
  
  has_many :value_orders
  has_many :keyword_pages,:through => :value_orders,:source => :keyword_page
  has_many :appear_keyword_pages,:through => :value_orders,:source => :keyword_page,:order => "value DESC",:limit => 10
  has_many :news
  has_many :comments
  has_many :commented_resources,:through => :comments,:source => :resource
  has_many :replies
  has_many :replied_resources,:through => :replies,:source => :resource
  has_many :resources
  has_many :important_days
  has_many :be_follows
  has_many :followers,
    :through => :be_follows,
    :class_name => "User"
  has_many :resources
  has_one :portrait
  has_one :true_portrait

  named_scope :by_value,:order => "value DESC"

  accepts_nested_attributes_for :true_portrait, :allow_destroy => true
  accepts_nested_attributes_for :portrait, :allow_destroy => true
  accepts_nested_attributes_for :keyword_pages, :allow_destroy => true

  validates_confirmation_of :password,:message => "不一致"
  validates_inclusion_of :sex,:within => 0..1,:message => "请选择你的性别",:on => :update
  validates_uniqueness_of :username,:case_sensitive => false
  validates_format_of :username,:with => %r{^\w+$},:message =>"请避免使用太诡异的字符及汉字"
  validates_length_of :nick_name,:maximum=>10,:on => :update
  validates_length_of :username,:within => 4..20,:message => "请保持在4到20个字节内"
  validates_length_of :name,:within =>2..4,:on => :update,:if => Proc.new { |user| user.name.present?},:message => "真实姓名会使朋友更快找到你，你的隐私不会被泄露"
  validates_length_of :city,:within => 2..5,:message => "快速找到你周围的朋友",:on => :update
  validates_presence_of :nick_name,:on => :update
  validates_acceptance_of :terms,:message => '请同意服务条款以继续...',:on => :create,:accept => 1
  # how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  before_save :encrypt_password

  def self.authenticate(username, password)
    return nil if username.blank? or password.blank?
    u = find :first, :conditions => ['username = ? ', username] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def self.high_resources
    x=(self.all.length/4).to_i
    users=self.find(:all,:limit => x)
    ids=users.map do |u|
      u.id
    end
    Resource.find_all_by_user_id(ids,:order => "resources.created_at DESC")
  end

  def total_value
    ids=self.keyword_pages.map do |k|
      k.id
    end

    vs=ValueOrder.find_all_by_keyword_page_id_and_user_id(ids,self.id)
    vs.sum {|item| item.value}
  end
#  Below methods are the user self,he is active,not positive.ie.He treat others as friends/strangers.
  def followings
    b=BeFollow.scoped_by_follower_id(self.id)
    user_ids=b.map do |a|
      a.user.id
    end
    User.find_all_by_id(user_ids)
  end

  def name_or_nick_name(current_user)
    if self==current_user
      "我"
    else
      self.nick_name
    end
  end
  
  def controlled_keywords
    pages=self.keyword_pages
    ks=pages.map do |p|
      if p.top_user==self
        p.keyword
      else
        nil
      end
    end
    ks.compact
  end

end