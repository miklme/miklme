class SearchedKeywordsController < ApplicationController
  auto_complete_for :resource,:keywords,:limit => 50
  def new

  end

  def create
    render :update do |page|
      page.redirect_to "/search/#{params[:keywords]}"
    end
    s=SearchedKeyword.create(:name => params[:keywords])
    current_user.searched_keywords<<s
  end

  def index
    resources=Resource.scoped_by_keywords(params[:keywords])
    @users = resources.map do |r|
      r.author
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end
end
