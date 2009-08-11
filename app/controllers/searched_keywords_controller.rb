class SearchedKeywordsController < ApplicationController
  auto_complete_for :resource,:keywords,:limit => 50
  def new

  end

  def notice
    render :update do |page|
      page.hide "body"
    end
  end

  def create
    keyword_page=KeywordPage.find_by_keyword(params[:keywords])
    render :update do |page|
      page.redirect_to "/keyword_pages/#{keyword_page.id}"
    end
    if current_user.searched_keywords.find_by_name(params[:keywords]).blank?
      s=current_user.searched_keywords.create(:name => params[:keywords])
    else
      s=current_user.searched_keywords.find_by_name(params[:keywords])
      s.searched_times=s.searched_times+1
      s.save
    end
  end
end
