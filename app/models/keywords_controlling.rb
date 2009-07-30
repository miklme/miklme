class KeywordsControlling < ActiveRecord::Base
  belongs_to :controlled_keyword
  belongs_to :user
end
