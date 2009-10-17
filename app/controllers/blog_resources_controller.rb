class BlogResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  before_filter :load_user,:except => [:say]
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
      @keyword_page.updated_at==Time.now
      @keyword_page.save
      if not current_user.keyword_pages.include?(@keyword_page)
        v=ValueOrder.new
        v.user=current_user
        v.keyword_page=@keyword_page
        v.actived=true
        v.save
      end
      flash[:keyword_page]=@blog_resource.keyword_page.id
      n=current_user.news.create
      n.news_type="blog_resource"
      n.owner=current_user
      n.resource=@blog_resource
      n.save
      render :update do |page|
        page.replace_html "succeed", "<p>发表成功。按照规则，你的想法会根据你的声望排序。</p>"
        page.visual_effect(:appear,"succeed",:duration => 2)
        page.insert_html :top,"new",:partial => "resources/resource",:object => @blog_resource
        page.visual_effect(:pulsate, "new",:duration => 4)
      end
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

  def say
    render :update do |page|
      page.toggle "form"
      page.toggle "succeed"
    end
  end
  
end
