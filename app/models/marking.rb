class Marking < ActiveRecord::Base
  belongs_to :user
  belongs_to :resource

  validates_length_of :comment,:maximum => 140
  validates_length_of :title,:maximum => 14
  validates_exclusion_of :value ,:in => -1..1
  validates_presence_of :content
end
