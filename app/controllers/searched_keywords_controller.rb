class SearchedKeywordsController < ApplicationController
  def new
    @new_keywords=Resource.new_keywords
    @high_keywords=User.high_keywords
    @top_users=User.find(:all,:limit => 15)
  end


  def auto_complete_for_resource_keywords
    keyword_pages=KeywordPage.find_with_ferret(params[:resource][:keywords]+"~")
    k2=keyword_pages.map do |k|
      k.keyword
    end
    @keywords=k2.uniq.first(15)
    render :layout => false
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

  def about_all_keywords
    render :update do |page|
      page.visual_effect :toggle_blind,"more"
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
