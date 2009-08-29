require 'rmmseg'
require 'rmmseg/ferret'

class Resource < ActiveRecord::Base
  acts_as_ferret({
      :fields=>{
        :keywords=>{
          :store=>:yes,
          #:boost => 2
          #可以设置权重
        },
        :content => {
          :store => :yes
        }
      },
      #  :remote => true,
      #  生产环境下别忘记。
      :store_class_name=>true,
      :analyzer=>RMMSeg::Ferret::Analyzer.new
    })
  
  belongs_to :owner,:class_name => 'User',:foreign_key =>"user_id"
  default_scope :include => :owner,:order => 'users.value DESC'
  named_scope :by_time,:order => "created_at DESC"
  named_scope :in_one_day,:conditions => ["resources.created_at > ?",Time.now.yesterday]
  named_scope :by_owner_value,:include => :owner,:order => 'users.value DESC'
  private
  def adjust_link_url
    if  !self.link_url=~/http:/ and !self.link_url=~/https:/ and  !self.link_url=~/ftp:/ and  !self.link_url=~/sftp:/
      self.link_url = ("http://"+self.link_url).to_s
    end
  end

end
