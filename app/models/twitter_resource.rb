class TwitterResource<Resource
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :content => {
          :store => :yes
        },
        :created_at_s=>{:index=>:untokenized,:store=>:yes},
        :by_user_value => {:index=>:untokenized,:store => :yes}
      },
        :remote => true,
      #  生产环境下别忘记。
      :store_class_name=>true,
      :ferret => {:analyzer => analyzer}
    })

  
  has_many :replies,:foreign_key => "resource_id"
  has_many :repliers,:through => :replies,:source => :user

  validates_length_of :content,:maximum => 130,:message => "内容有点长了。请保持在130字以内。"
  validates_presence_of :content,:message => "请填写完全"

  def by_user_value
    self.owner.value
  end
end
