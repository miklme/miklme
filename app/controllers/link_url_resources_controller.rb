class LinkUrlResourcesController < ApplicationController
  before_filter :load_user
  def new
    if not current_user.keyword_pages.include?(@keyword_page)
      v=ValueOrder.new
      v.user=current_user
      v.keyword_page=@keyword_page
      v.actived=true
      v.save
    end
    @link_url_resource=current_user.link_url_resources.build
  end

  def edit
    @link_url_resource=LinkUrlResource.find(params[:id])
  end

  def create
    @keyword_page=KeywordPage.find(session[:current_keyword_page_id])
    @link_url_resource=@user.link_url_resources.build(params[:link_url_resource])
    @link_url_resource.keyword_page=@keyword_page
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

end
