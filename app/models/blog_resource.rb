class BlogResource<Resource
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
  has_many :comments,:foreign_key => "resource_id",:dependent => :destroy
  has_many :commenters,:through => :comments,:source => :owner,:conditions => "parent_comment_id is NULL"
  has_many :good_commenters,:through => :comments,:source => :owner,:conditions => "rating>0 and parent_comment_id is NULL"
  has_many :bad_commenters,:through => :comments,:source => :owner,:conditions => "rating<0 and parent_comment_id is NULL"

  validates_presence_of :content
  validates_length_of :content,:maximum => 280
end
