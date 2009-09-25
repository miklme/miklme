class BlogResource<Resource
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :title => {
          :store => :yes,
          :boost=> 20 #设置权重
        },
        :body => {
          :boost=> 5,
          :store => :yes,
        },
        :created_at_s=>{:index=>:untokenized,:store=>:yes},
        :by_user_value => {:index=>:untokenized,:store => :yes}
      },
      :remote => true,
      #  生产环境下别忘记。
      :store_class_name=>true,
      :ferret => {:analyzer => analyzer}
    })

  
  has_many :comments,:foreign_key => "resource_id",:dependent => :destroy
  has_many :commenters,:through => :comments,:source => :owner

  validates_length_of :content,:minimum => 120
  validates_length_of :title,:within => 1..30
end
