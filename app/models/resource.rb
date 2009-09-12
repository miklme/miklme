require 'rmmseg'
require 'rmmseg/ferret'

class Resource < ActiveRecord::Base

  belongs_to :owner,:class_name => 'User',:foreign_key =>"user_id"
  default_scope :include => :owner,:order => 'users.value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :in_one_day,:conditions => ["resources.created_at > ?",Time.now.yesterday]
  named_scope :by_owner_value,:include => :owner,:order => 'users.value DESC'
  

  #这个方法不能用于ruby1.8.6
  #  def self.hot_keywords
  #    keywords=Resource.find(:all,:order => "resources.created_at DESC",:limit => 10000).map do |r|
  #      r.keywords
  #    end
  #    keywords=keywords.compact
  #    uniqed_keywords=keywords.uniq.sort_by { |k| Resource.find_by_keywords(k).count(k) }
  #    uniqed_keywords.first(50)
  #  end

  def created_at_s
    created_at.advance(:hours => 8).to_s(:db)
  end
  
  def updated_at_s
    updated_at.advance(:hours => 8).to_s(:db)
  end

  def self.search_by_keywords(keywords,page)
    resources=Resource.find_all_by_type(["LinkUrlResource","BlogResource"])
    resources.paginate :per_page => 10,
      :page => page,
      :conditions => ["keywords=?",keywords],
      :include => :owner,
      :order => 'users.value DESC'
  end

  def self.search_by_keywords_and_form(keywords,form,page)
    resources=Resource.find_all_by_type(["LinkUrlResource","BlogResource"])
    resources.paginate :per_page => 10,
      :page => page,
      :conditions => ["keywords=:keywords and form=:form",{:keywords =>keywords,:form => form }]
  end

  def self.find_by_user(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["user_id=? and keywords is NOT NULL",user.id]
  end

  def self.authority_resources(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["resources.authority = :true and user_id=:user_id and keywords is NOT NULL",{:true =>true,:user_id => user.id }]
  end

  def self.not_authority_resources(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["resources.authority = :false and user_id=:user_id and keywords is NOT NULL",{:false =>false,:user_id => user.id }]
  end

  def self.new_keywords
    keywords=Resource.find(:all,:order => "resources.created_at DESC",:limit => 1000).map do |r|
      r.keywords
    end
    keywords.compact.uniq.first(15)
  end
  
  private
  def adjust_link_url
    if  !self.link_url=~/http:/ and !self.link_url=~/https:/ and  !self.link_url=~/ftp:/ and  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end

end
