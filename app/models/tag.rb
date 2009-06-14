class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :resources,:through => :taggings,:uniq => true
end
