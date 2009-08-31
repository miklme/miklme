class TruePortrait < ActiveRecord::Base
  belongs_to :user

#  acts_as_fleximage :image_directory => 'public/upload_portraits'
#  use_creation_date_based_directories true
#  image_storage_format :jpg
#  require_image true
#  missing_image_message  '被要求'
#  invalid_image_message '的格式无法被读取'
#  default_image_path 'public/images/rails.png'
#  output_image_jpg_quality  85
#  preprocess_image do |image|
#    image.resize '200x200'
#  end
end
