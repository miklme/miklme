class BlogResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  def show
    @blog_resource=Resource.find(params[:id])
  end

  def create
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
    @blog_resource=@keyword_page.blog_resources.build(params[:blog_resource])
    @blog_resource.authority=true
    @blog_resource.owner=current_user
    if @blog_resource.save
      @keyword_page.updated_at=Time.now
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
      flash[:notice]="<h2 class='item_pink'>发表成功。默认情况下，你的想法会根据你的<cite>声望</cite>排序，你可以在下面找找看。</h2>"
      redirect_to :back
    else
      flash[:notice]="<p class='highlight'>你什么都没有写，或者内容太长了（超过了600字）</p>"
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
