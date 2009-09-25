class BlogResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  before_filter :load_user,:user_keywords,:except => [:auto_complete_for_keyword_page_keyword]
  def new
    @blog_resource=current_user.blog_resources.build
  end

  def show
    @blog_resource=Resource.find(params[:id])
  end

  def edit
    @blog_resource=BlogResource.find(params[:id])

  end

  def index
    @blog_resources=@user.blog_resources
  end

  def create
    @blog_resource=current_user.blog_resources.build(params[:blog_resource])
    @blog_resource.authority=true
    @blog_resource.before_save_or_update(params[:blog_resource][:keywords])
    if  @blog_resource.errors.blank?
      if @blog_resource.save
        render :partial => "link_url_resources/succeed",:layout => "blog_resources"
        n=current_user.news.create
        n.news_type="blog_resource"
        n.owner=current_user
        n.resource=@blog_resource
        n.save
      else
        render :action => :new,:layout => "blog_resources"
      end
    else
      render :action => :new,:layout => "blog_resources"
    end
  end

  def update
    @blog_resource=@user.blog_resources.find(params[:id])
    @blog_resource.update_attributes(params[:blog_resource])
    @blog_resource.before_save_or_update(params[:blog_resource][:keywords])
    if @blog_resource.save
      flash[:notice]="修改成功。"
      redirect_to keyword_page_path(@blog_resource.keyword_page)
    else
      render :action => :edit,:layout => "blog_resources"
    end
  end
  private
  def user_keywords
    @ks=@user.appear_keyword_pages
  end
end
