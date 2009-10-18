class BlogResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  def show
    @blog_resource=Resource.find(params[:id])
  end

  def index
    @blog_resources=@user.blog_resources
  end

  def create
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
    @blog_resource=@keyword_page.blog_resources.build(params[:blog_resource])
    @blog_resource.authority=true
    @blog_resource.owner=current_user
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

  def say
    render :update do |page|
      page.toggle "form"
      page.toggle "succeed"
    end
  end
  
end
