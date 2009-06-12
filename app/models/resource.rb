class Resource < ActiveRecord::Base
  acts_as_taggable

  has_many :markings
  has_many :markers,:through => :markings,:source => :user
end
