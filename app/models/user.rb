require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  has_one :portrait
  has_many :important_days
  accepts_nested_attributes_for :portrait, :allow_destroy => true
  accepts_nested_attributes_for :important_days,:allow_destroy => true

  validates_format_of :name,:with => /\A[^[:cntrl:]\\<>\/&]*\z/,:message =>"请避免使用太过诡异的字符，如 %@#<等。"
  validates_format_of :email,:with => Authentication.email_regex,:message => Authentication.bad_email_message
  validates_length_of :email,:within => 6..100 #r@a.wk
  validates_length_of :nick_name,:name,:maximum=>10,:on => :update
  validates_uniqueness_of :email
  validates_presence_of :email
  validates_presence_of :nick_name,:name,:on => :update
 
  # how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.

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
