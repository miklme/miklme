class StartController < ApplicationController
  auto_complete_for :resource,:keywords,:limit => 50
  def michael

  end
 
  def search
    render :update do |page|
      page.redirect_to "/search/#{params[:keywords]}"
    end
  end

  def index
    @resources = Resource.search_result(params[:keywords]).find(:all,:group => 'user_id')
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end
end
