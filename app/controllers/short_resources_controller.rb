class ShortResourcesController < ApplicationController
  def index
    @resources = Resource.search_result(params[:keywords])
    @users=@resources.map do |resource|
      resource.author
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end

  def show
  end

  def edit
  end


end
