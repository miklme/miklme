class BlogResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  before_filter :load_user
  def new
    @keyword_page=KeywordPage.find(session[:current_keyword_page_id])
    if not current_user.keyword_pages.include?(@keyword_page)
      v=ValueOrder.new
      v.user=current_user
      v.keyword_page=@keyword_page
      v.actived=true
      v.save
    end
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
    @keyword_page=KeywordPage.find(session[:current_keyword_page_id])
    @blog_resource=@user.blog_resources.build(params[:blog_resource])
    @blog_resource.authority=true
    @blog_resource.keyword_page=@keyword_page
    if @blog_resource.save
      flash[:keyword_page]=@blog_resource.keyword_page.id
      render :partial => "link_url_resources/succeed",:layout => "blog_resources"
      n=current_user.news.create
      n.news_type="blog_resource"
      n.owner=current_user
      n.resource=@blog_resource
      n.save
    else
      redirect_to :back
    end
  end

  def update
    @blog_resource=@user.blog_resources.find(params[:id])
    @blog_resource.update_attributes(params[:blog_resource])
    if @blog_resource.save
      flash[:notice]="修改成功。"
      redirect_to keyword_page_path(@blog_resource.keyword_page)
    else
      render :action => :edit,:layout => "blog_resources"
    end
  end
  
end
