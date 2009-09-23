class ControlledKeywordsController < ApplicationController
  before_filter :load_user
  # GET /keywords
  # GET /keywords.xml
  def index
    @controlled_keywords=@user.controlled_keywords
  end
  
  # GET /keywords/1.xml
  def show
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @keyword }
    end
  end


end
