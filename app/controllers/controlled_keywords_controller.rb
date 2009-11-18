class ControlledKeywordsController < ApplicationController
  before_filter :load_user
  # GET /keywords
  # GET /keywords.xml
  def index
    @controlled_keywords=@user.controlled_keywords
    @followings=@user.followings.paginate(:page => params[:page],:per_page => 15)
  end
  

end
