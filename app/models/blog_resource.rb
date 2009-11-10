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

  acts_as_fleximage :image_directory => 'public/images/resource_pictures'
  use_creation_date_based_directories true
  image_storage_format :jpg
  require_image false
  missing_image_message  '被要求'
  invalid_image_message '的格式无法被读取'
  output_image_jpg_quality  85
  preprocess_image do |image|
    image.resize '200x200'
  end
  has_many :comments,:foreign_key => "resource_id",:dependent => :destroy
  has_many :commenters,:through => :comments,:source => :owner,:conditions => "parent_comment_id is NULL"
  has_many :good_commenters,:through => :comments,:source => :owner,:conditions => "rating>0 and parent_comment_id is NULL"
  has_many :bad_commenters,:through => :comments,:source => :owner,:conditions => "rating<0 and parent_comment_id is NULL"

  validates_presence_of :content
  validates_length_of :content,:maximum => 280
end
