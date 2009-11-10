class BlogResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  def show
    @blog_resource=Resource.find(params[:id])
  end

  def create
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
    @blog_resource=@keyword_page.blog_resources.build(params[:blog_resource])
    @blog_resource.owner=current_user
    if @blog_resource.save
      @keyword_page.updated_at=Time.now
      @keyword_page.save
      n=current_user.news.create
      n.news_type="blog_resource"
      n.owner=current_user
      n.resource=@blog_resource
      n.save
      flash[:notice]="<h2 class='item_orange'>发表成功。默认情况下，你发表的内容会根据你的<cite>声望</cite>排序，你可以在下面找找看。</h2>"
      redirect_to :back
    else
      flash[:notice]="<p class='highlight'>对不起，你发表的内容超过了280个字。</p>"
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
