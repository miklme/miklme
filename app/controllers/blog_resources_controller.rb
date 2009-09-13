class BlogResourcesController < ApplicationController
  before_filter :find_user,:except => [:auto_complete_for_keyword_page_keyword]
  auto_complete_for :keyword_page,:keyword,:limit => 7

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
    @blog_resource.keywords=params[:keyword_page][:keyword]
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

   def update
    @blog_resource=@user.blog_resources.find(params[:id])
    @blog_resource.update_attributes(params[:blog_resource])
    @blog_resource.keywords=params[:keyword_page][:keyword]
    if @blog_resource.save
      KeywordPage.create(:keyword => @blog_resource.keywords)
      flash[:notice]="修改成功。"
      redirect_to keyword_page_path(KeywordPage.find_by_keyword(@blog_resource.keywords))
    end
  end
  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
