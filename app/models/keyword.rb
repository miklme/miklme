class Keyword < ActiveRecord::Base
  has_many :kaos
  has_many :owners,:source => :user,:through => :kaos
end
