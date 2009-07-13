require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  default_scope :order => 'value DESC'
  named_scope :value,:order => 'value DESC'

  has_many :keywords
  has_many :searched_keywords
  has_many :comments
  has_many :resources
  has_many :friendships
  has_many :friends,
    :through => :friendships,
    :source => :user,
    :class_name => 'User'
  has_many :important_days
  has_many :followings,
    :class_name => "User",
    :order => "value DESC",
    :foreign_key => 'follower_id'
  has_one :portrait
  has_one :true_portrait
  belongs_to :follower,
    :class_name => 'User',
    :foreign_key => 'follower_id'

  accepts_nested_attributes_for :true_portrait, :allow_destroy => true
  accepts_nested_attributes_for :portrait, :allow_destroy => true
  accepts_nested_attributes_for :important_days,:allow_destroy => true

  validates_format_of :name,:with => /\A[^[:cntrl:]\\<>\/&]*\z/,:message =>"请避免使用太过诡异的字符，如 %@#<等。"
  validates_format_of :email,
    :with =>/\A#{'[\w\.%\+\-]+'}@#{'(?:[A-Z0-9\-]+\.)+'}#{'(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)'}\z/i,
    :message => "在Michael看来并不合理"
  validates_length_of :nick_name,:name,:maximum=>10,:on => :update
  validates_uniqueness_of :email
  validates_presence_of :nick_name,:on => :update
  validates_acceptance_of :terms,:message => '请同意我们的服务条款以继续',:on => :create,:accept => 1
  # how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  before_save :encrypt_password
  before_create :make_activation_code
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end

  def inactived
    activation_code.exist?
  end

  def self.authenticate(email, password)
    return nil if email.blank? or password.blank?
    u = find :first, :conditions => ['email = ? and activated_at IS NOT NULL', email] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  def check_activation_status(email)
    if User.find_by_email(email) and !User.find_by_email(email).active?
      User.find_by_email(email).destroy
    end
  end

  private
    
  def make_activation_code
    self.activation_code = self.class.make_token
  end

end
