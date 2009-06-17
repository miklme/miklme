class Resource < ActiveRecord::Base
  has_many :markings
  has_many :markers,:through => :markings,:source => :user
end
