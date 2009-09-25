class TwitterResource<Resource
  has_many :replies,:foreign_key => "resource_id"
  has_many :repliers,:through => :replies,:source => :user

  validates_length_of :content,:maximum => 130,:message => "内容有点长了。请保持在130字以内。"
  validates_presence_of :content,:message => "请填写完全"



  def self.find_by_user(user,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["user_id=?",user.id]
  end
end
