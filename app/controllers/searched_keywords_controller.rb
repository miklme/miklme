class SearchedKeywordsController < ApplicationController
  skip_before_filter :login_required
  def new
    @new_keyword_pages=KeywordPage.find(:all,:order => "created_at DESC",:limit => 15)
    @keyword_pages=KeywordPage.find(:all)
  end


  def auto_complete_for_keyword_page_keyword
    keyword_pages=KeywordPage.find_with_ferret(params[:keyword_page][:keyword]+"~")
    @keyword_pages=keyword_pages.first(15)
    render :layout => false
  end

  def create
    keyword_page=KeywordPage.find_by_keyword(params[:keyword])
    render :update do |page|
      page.redirect_to keyword_page_path(keyword_page)
    end
  end

  def search_link_url
    render :update do |page|
      page.visual_effect(:fade,"search_twitter",:duration => 0.5)
      page.visual_effect(:appear,"search_link_url",:duration => 1,:delay => 0.5)
    end
  end

  def search_twitter
    render :update do |page|
      page.visual_effect(:fade,"search_link_url",:duration => 0.5)
      page.visual_effect(:appear,"search_twitter",:duration => 1,:delay => 0.5)
    end
  end
end
