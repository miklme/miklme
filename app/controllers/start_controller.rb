class StartController < ApplicationController
  auto_complete_for :resource,:keywords,:limit => 50
  def michael

  end
 
  def search
    render :update do |page|
      page.redirect_to "/search/#{params[:keywords]}"
    end
    s=SearchedKeyword.create(:name => params[:keywords])
    current_user.searched_keywords<<s
  end

  def index
    @resources = Resource.search_result(params[:keywords])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end
end
