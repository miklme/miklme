class LinkUrlResource< Resource
  analyzer = RMMSeg::Ferret::Analyzer.new
  acts_as_ferret({
      :fields=>{
        :description => {
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


  has_many :comments,:foreign_key => "resource_id"
  has_many :commenters,:through => :comments,:source => :owner
  validates_format_of :link_url, :with => %r{[a-zA-z]+://[^\s]*},:message => "看看是否包含了http://"
  validates_length_of :description,:within => 1..30
  validates_length_of :link_url,:maximum => 1000
  named_scope :hot_resources,:include => :comments,:condition => "comments.size>10"


end
