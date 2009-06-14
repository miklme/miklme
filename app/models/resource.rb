class Resource < ActiveRecord::Base
  has_many :taggings
  has_many :tags,:dependent => :destroy,:through => :taggings,:uniq =>true,:limit => 3
  has_many :markings
  has_many :markers,:through => :markings,:source => :user,:uniq => true
end
