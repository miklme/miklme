class UserShortResourcesController < ApplicationController
  def index
    @resources = Resource.search_result(params[:keywords])
    @user_short_resources=@resources.map do |resource|
      resource.author
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end

  def new
   
  end

  def edit
  end
  
end
