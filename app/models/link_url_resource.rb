class LinkUrlResource< Resource
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :keywords => {
          :store => :yes
        },
        :created_at_s=>{:index=>:untokenized,:store=>:yes},
      },
      #  :remote => true,
      #  生产环境下别忘记。
      :store_class_name=>true,
      :ferret => {:analyzer => analyzer}
    })
  
  has_many :comments,:foreign_key => "resource_id"
  has_many :commenters,:through => :comments,:source => :user
  validates_presence_of :keywords,:message => "这是别人看到你的条目的最重要的渠道"
  validates_presence_of :description,:message => "请随意"
  validates_presence_of :link_url,:message => "请填写链接地址。"
  validates_inclusion_of :form,:in => %w{视频 音频 图片 文字、文档},:message => "请指定目标链接所包含内容的类型"
  validates_format_of :link_url, :with => %r{[a-zA-z]+://[^\s]*},:message => "看看是否包含了http://"
  validates_length_of :keywords,:maximum => 20

  named_scope :hot_resources,:include => :comments,:condition => "comments.size>10"

  def self.search_by_keywords(keywords,page)
    paginate :per_page => 10,
      :page => page,
      :conditions => ["keywords=?",keywords],
      :include => :owner,
      :order => 'users.value DESC'
  end

  def self.search_by_keywords_and_form(keywords,form,page)
    paginate :per_page => 10,
      :page => page,
      :conditions => ["keywords=:keywords and form=:form",{:keywords =>keywords,:form => form }]
  end

end
