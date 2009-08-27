class SearchedKeywordsController < ApplicationController
  auto_complete_for :link_url_resource,:keywords,:limit => 15
  def new

  end

  def notification
    #    re=Regexp.new("^#{params[:resource][:keywords]}","i")
    #    @resources=Resource.all do |r|
    #      r.keywords.to_s.match re
    #    end
#    render :update do |page|
#      page.replace_html  "notification","当您幸运的发现关键字没有出现在列表中时，就意味着您可以任意编辑该关键字的内容，从而被别人看见。"
#    end
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
