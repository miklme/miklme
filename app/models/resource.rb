class Resource < ActiveRecord::Base
  
  belongs_to :keyword_page
  belongs_to :owner,:class_name => 'User',:foreign_key =>"user_id"
  default_scope :order => "created_at DESC"
  named_scope :in_one_day,:conditions => ["resources.created_at > ?",Time.now.yesterday]
  named_scope :recent,:limit => 10,:order => "created_at DESC"
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


  def comments_by_value(page)
    cs=self.comments.parent_comments
    comments=cs.sort_by do |c|
      c.owner.value(c.resource.keyword_page)
    end
    comments.reverse.paginate(:per_page => 10,:page => page)
  end

  def comments_by_time(page)
    self.comments.parent_comments.paginate(:per_page => 10,:page => page,:order => "created_at DESC")
  end

  def self.find_by_user(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["user_id=?",user.id],
      :order => "resources.created_at DESC"
  end


  def self.authority_resources(user,page)
    paginate :per_page => 15,
      :page => page,
      :order => "resources.created_at DESC",
      :conditions => ["resources.authority = :true and user_id=:user_id",{:true =>true,:user_id => user.id }]
  end

  def self.not_authority_resources(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["resources.authority = :false and user_id=:user_id",{:false =>false,:user_id => user.id }],
      :order => "resources.created_at DESC"
  end


  def description_or_title
    if self.class.to_s=="LinkUrlResource"
      description
    elsif self.class.to_s=="BlogResource"
      title
    end
  end

  def before_save_or_update(params)
    keyword_page=self.owner.keyword_pages.find_by_keyword(params)
    if keyword_page.present?
      self.keyword_page=keyword_page
    else
      self.errors.add("领域")
    end
  end
  private
  def adjust_link_url
    if  !self.link_url=~/http:/ and !self.link_url=~/https:/ and  !self.link_url=~/ftp:/ and  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end

end
