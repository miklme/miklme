class LinkUrlResourcesController < ApplicationController
  before_filter :user_keywords,:except => [:auto_complete_for_keyword_page_keyword]
  def new
    if not current_user.keyword_pages.include?(@keyword_page)
      v=ValueOrder.new
      v.user=current_user
      v.keyword_page=@keyword_page
      v.actived=true
      v.save
    end
    @link_url_resource=@keyword_page.link_url_resources.build
  end

  def edit
    @link_url_resource=LinkUrlResource.find(params[:id])
  end

  def create
    @link_url_resource=@keyword_page.link_url_resources.build(params[:link_url_resource])
    @link_url_resource.owner=current_user
    if @link_url_resource.save
      flash[:keyword_page]=@link_url_resource.keyword_page.id
      render :partial => "succeed",:layout => "link_url_resources"
      n=current_user.news.create
      n.news_type="link_url_resource"
      n.owner=current_user
      n.resource=@link_url_resource
      n.save
    else
      render :action => :new
    end
  end

  private
  def user_keywords
    @user=current_user
    @ks=@user.appear_keyword_pages
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
  end
end
