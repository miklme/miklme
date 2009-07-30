class SearchedKeywordsController < ApplicationController
  auto_complete_for :resource,:keywords,:limit => 50
  def new

  end

  def create
    render :update do |page|
      page.redirect_to "/search/#{params[:keywords]}"
    end
    if current_user.searched_keywords.find_by_name(params[:keywords]).blank?
      s=SearchedKeyword.create(:name => params[:keywords])
      current_user.searched_keywords<<s
    else
      s=current_user.searched_keywords.find_by_name(params[:keywords])
      s.searched_times=s.searched_times+1
      s.save
    end
  end
  
  def index
   
  end
end
