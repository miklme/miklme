class BlogResourcesController < ApplicationController
  before_filter :find_user,:except => [:auto_complete_for_resource_keywords]
  auto_complete_for :resource,:keywords,:limit => 7

  def new
    @blog_resource=current_user.blog_resources.build
  end

  def show
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
    @blog_resource.form="文字、文档"
    if @blog_resource.save
      KeywordPage.create(:keyword => @blog_resource.keywords)
      render :partial => "link_url_resources/succeed",:layout => "blog_resources"
      n=current_user.news.create
      n.news_type="blog_resource"
      n.owner=current_user
      n.resource=@blog_resource
      n.save
    else
      render :action => :new,:layout => "blog_resources"
    end
  end
  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
