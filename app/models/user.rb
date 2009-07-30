require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  default_scope :order => 'value DESC'
  named_scope :value,:order => 'value DESC'

  has_many :controlled_keywords
  has_many :owned_keywords
  has_many :searched_keywords
  has_many :comments
  has_many :commented_resources,:through => :comments,:source => :resource
  has_many :resources
  has_many :important_days
  has_many :followings,
    :class_name => "User",
    :order => "value DESC",
    :foreign_key => 'follower_id'
  has_many :link_url_resources
  has_many :blog_resources
  has_many :twitter_resources
  has_one :address
  has_one :portrait
  has_one :true_portrait
  has_many :followers,
    :class_name => 'User',
    :foreign_key => 'following_id'

  accepts_nested_attributes_for :true_portrait, :allow_destroy => true
  accepts_nested_attributes_for :portrait, :allow_destroy => true
  accepts_nested_attributes_for :important_days,:allow_destroy => true

  validates_uniqueness_of :username
  validates_format_of :username,:with => %r{^[a-zA-Z][a-zA-Z0-9_]{4,15}$},:message =>"请避免使用太过诡异的字符及汉字"
  validates_length_of :nick_name,:maximum=>10,:on => :update
  validates_length_of :username,:within => 5..20,:message => "请保持在5到20个字节内"
  validates_length_of :name,:maximum => 4,:on => :update,:message => "请填写真实姓名"
  validates_presence_of :nick_name,:name,:on => :update
  validates_acceptance_of :terms,:message => '请同意服务条款以继续',:on => :create,:accept => 1
  # how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  before_save :encrypt_password

  def self.authenticate(username, password)
    return nil if username.blank? or password.blank?
    u = find :first, :conditions => ['username = ? ', username] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end


end
