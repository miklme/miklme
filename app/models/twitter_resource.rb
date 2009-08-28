class TwitterResource<Resource
  has_many :replies,:foreign_key => "resource_id"
  has_many :repliers,:through => :replies,:source => :user

  validates_length_of :content,:maximum => 130,:message => "内容有点长了。请保持在130字以内。"
  validates_presence_of :content,:message => "请填写完全"

  def self.search_by_content(content,page)
    paginate :per_page => 15,
      :page => page,
      :conditions => ["resources.content like ?","%"+content+"%"],
      :include => :owner,
      :order => 'users.value DESC'
  end
end
