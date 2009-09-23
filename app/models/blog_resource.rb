class BlogResource<Resource
  has_many :comments,:foreign_key => "resource_id"
  has_many :commenters,:through => :comments,:source => :owner

  validates_length_of :content,:minimum => 150
  validates_length_of :title,:within => 1..30
end
