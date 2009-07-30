class ControlledKeyword < ActiveRecord::Base
  has_many :keywords_controllings
  has_many :owners,:source => :user,:through => :keywords_controllings
  has_one :top_owner,:source => :user,:through => :keywords_controllings,:order => "value DESC"
end
