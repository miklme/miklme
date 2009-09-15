class SearchedKeywordsController < ApplicationController
  def new
    @new_keywords=Resource.new_keywords
    @high_keywords=User.high_keywords
    @top_users=User.find(:all,:order => "value DESC",:limit => 15)
  end


  def auto_complete_for_resource_keywords
    link_url_resources=LinkUrlResource.find_with_ferret(params[:resource][:keywords]+"~")
    blog_resources=BlogResource.find_with_ferret(params[:resource][:keywords]+"~")
    keywords1=link_url_resources.map do |l|
      l.keywords
    end
    keywords2=blog_resources.map do |l|
      l.keywords
    end
    @keywords=(keywords1+keywords2).uniq.first(15)
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
      page.visual_effect(:hide,"search_twitter")
      page.visual_effect(:appear,"search_link_url",:duration => 2)
    end
  end

  def search_twitter
    render :update do |page|
      page.visual_effect(:hide,"search_link_url")
      page.visual_effect(:appear,"search_twitter",:duration => 2)
    end
  end
end
