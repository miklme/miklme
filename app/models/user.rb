require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  default_scope :order => 'value DESC'
  named_scope :by_value,:order => 'value DESC'

  has_many :searched_keywords
  has_many :comments
  has_many :commented_resources,:through => :comments,:source => :resource
  has_many :resources
  has_many :important_days
  has_many :be_follows
  has_many :followers,
    :through => :be_follows,
    :class_name => "User"
  has_many :link_url_resources
  has_many :blog_resources
  has_many :twitter_resources
  has_one :address
  has_one :portrait
  has_one :true_portrait

  accepts_nested_attributes_for :true_portrait, :allow_destroy => true
  accepts_nested_attributes_for :portrait, :allow_destroy => true
  accepts_nested_attributes_for :important_days,:allow_destroy => true

  validates_uniqueness_of :username,:case_sensitive => false
  validates_format_of :username,:with => %r{^[a-zA-Z][a-zA-Z0-9_]{4,15}$},:message =>"请避免使用太过诡异的字符及汉字"
  validates_length_of :nick_name,:maximum=>10,:on => :update
  validates_length_of :username,:within => 5..20,:message => "请保持在5到20个字节内"
  validates_length_of :name,:within =>1..  4,:on => :update,:message => "真实姓名会使朋友更快找到你，Michael会保护你的隐私，不要担心"
  validates_presence_of :nick_name,:name,:on => :update
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

  def owned_keywords
    resources=self.link_url_resources
    resources.map do |r|
      r.keywords
    end
  end

  def followings
    b=BeFollow.scoped_by_follower_id(self.id)
    b.map do |a|
      a.user
    end
  end

  def real_friends
    b=BeFollow.scoped_by_follower_id(self.id).scoped_by_provide_name(true)
    b.map do |c|
      c.user
    end
  end

  def interested_people
    b=BeFollow.scoped_by_follower_id(self.id).scoped_by_provide_name(false)
    b.map do |c|
      c.user
    end
  end

  def regard_real_friend?(user)
    if BeFollow.find_by_user_id_and_follower_id(user.id,self.id).present? and BeFollow.find_by_user_id_and_follower_id(user.id,self.id).provide_name?
      true
    else
      false
    end
  end

  def interested_in?(user)
    if BeFollow.find_by_user_id_and_follower_id(user.id,self.id).present? and !BeFollow.find_by_user_id_and_follower_id(user.id,self.id).provide_name?
      true
    else
      false
    end
  end

  def controlled_keywords
    keywords=self.owned_keywords
    keywords.collect do |k|
      rs=Resource.scoped_by_keywords(k)
      owners=rs.map do |r|
        r.owner
      end
      top_keywords_owner=owners.find(:order => "value DESC,username").first
      if top_keywords_owner==self
        k
      else
        nil
      end
    end
  end
end