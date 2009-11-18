require 'rmmseg'
require 'rmmseg/ferret'

class Resource < ActiveRecord::Base
  #  analyzer = RMMSeg::Ferret::Analyzer.new
  #  acts_as_ferret({
  #      :fields=>{
  #        :content => {
  #          :store => :yes,
  #        },
  #        :created_at_s=>{:index=>:untokenized,:store=>:yes},
  #        :by_user_value => {:index=>:untokenized,:store => :yes}
  #      },
  #      :remote => true,
  #      #  生产环境下别忘记。
  #      :store_class_name=>true,
  #      :ferret => {:analyzer => analyzer}
  #    })

  acts_as_fleximage :image_directory => 'public/images/resource_pictures'
  use_creation_date_based_directories true
  image_storage_format :jpg
  require_image false
  invalid_image_message '的格式不对，或者不被支持'
  output_image_jpg_quality  100
  preprocess_image do |image|
    image.resize '1200x800'
  end
  has_many :comments,:foreign_key => "resource_id",:dependent => :destroy
  has_many :commenters,:through => :comments,:source => :owner,:conditions => "parent_comment_id is NULL"
  has_many :good_commenters,:through => :comments,:source => :owner,:conditions => "rating>0 and parent_comment_id is NULL"
  has_many :bad_commenters,:through => :comments,:source => :owner,:conditions => "rating<0 and parent_comment_id is NULL"

  validates_presence_of :content
  validates_length_of :content,:maximum => 280
  belongs_to :keyword_page
  has_many :news,:dependent => :destroy
  belongs_to :owner,:class_name => 'User',:foreign_key =>"user_id"
  default_scope :order => "created_at DESC"
  named_scope :in_one_day,:conditions => ["resources.created_at > ?",Time.now.yesterday]
  named_scope :recent,:limit => 15,:order => "resources.created_at DESC"

  after_save :check_if_first
  
  def created_at_s
    created_at.advance(:hours => 8).to_s(:db)
  end
  
  def updated_at_s
    updated_at.advance(:hours => 8).to_s(:db)
  end
  
  def by_user_value
    self.owner.total_value
  end

  def comments_by_value(page)
    cs=self.comments.parent_comments
    comments=cs.sort_by do |c|
      c.owner.field_value(c.resource.keyword_page)
    end
    comments.reverse.paginate(:per_page => 25,:page => page)
  end

  def comments_by_time(page)
    self.comments.parent_comments.paginate(:per_page => 20,:page => page,:order => "created_at")
  end

  def check_if_first
    if self.keyword_page.resources.size==1
      self.owner.change_value(self.keyword_page,1)
    end
  end
  def self.find_by_user(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["user_id=?",user.id],
      :order => "resources.created_at DESC"
  end


end
