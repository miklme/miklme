class Keyword < ActiveRecord::Base
  has_many :kaos
  has_many :owners,:source => :user,:through => :kaos
  has_one :top_owner,:source => :user,:through => :kaos,:order => "value DESC"
end
