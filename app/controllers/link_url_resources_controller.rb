class LinkUrlResourcesController < ApplicationController
  before_filter :load_user,:user_keywords,:except => [:auto_complete_for_keyword_page_keyword]
  def new
    @link_url_resource=current_user.link_url_resources.build
  end

  def edit
    @link_url_resource=LinkUrlResource.find(params[:id])
  end

  def create
    @link_url_resource=current_user.link_url_resources.build(params[:link_url_resource])
    @link_url_resource.before_save_or_update(params[:link_url_resource][:keywords])
    if @link_url_resource.errors.blank?
      if @link_url_resource.save
        render :partial => "succeed",:layout => "link_url_resources"
        n=current_user.news.create
        n.news_type="link_url_resource"
        n.owner=current_user
        n.resource=@link_url_resource
        n.save
      else
        render :action => :new,:layout => "link_url_resources"
      end
    else
      render :action => :new,:layout => "link_url_resources"
    end
  end

  def update
    @link_url_resource=@user.link_url_resources.find(params[:id])
    @link_url_resource.update_attributes(params[:link_url_resource])
    @link_url_resource.before_save_or_update(params[:link_url_resource][:keywords])
    if @link_url_resource.errors.blank?
      if  @link_url_resource.save
        flash[:notice]="修改成功。"
        redirect_to keyword_page_path(KeywordPage.find_by_keyword(@link_url_resource.keywords))
      else
        render :action => :edit,:layout => "link_url_resources"
      end
    else
      render :action => :edit,:layout => "link_url_resources"
    end
  end

  private
  def user_keywords
    @ks=@user.keyword_pages
  end
end
