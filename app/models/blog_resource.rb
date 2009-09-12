class BlogResource<Resource
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :keywords => {
          :store => :yes
        },
        :created_at_s=>{:index=>:untokenized,:store=>:yes},
      },
      :remote => true,
      #  生产环境下别忘记。
      :store_class_name=>true,
      :ferret => {:analyzer => analyzer}
    })

  has_many :comments,:foreign_key => "resource_id"
  has_many :commenters,:through => :comments,:source => :user

  validates_length_of :keywords,:within => 1..20
  validates_length_of :content,:minimum => 150
  validates_length_of :title,:within => 1..30
end
