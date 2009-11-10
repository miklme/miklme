class ResourcesController < ApplicationController
  skip_before_filter :login_required,:only => [:show]
  def new
    @keyword_page=KeywordPage.find(params[:id])
    if logged_in?
      @user=current_user
      @news=News.list_self_news(@user)
      @resource=@keyword_page.resources.build
    end
    keyword_pages=KeywordPage.find_with_ferret(@keyword_page.keyword+"~")-@keyword_page.to_a
    @searched_keywords=keyword_pages.find_all{|k| k.resources.size>=1}.first(10)
    #未使用用户自定义编辑贴吧功能
    @related_keywords=@keyword_page.related_keywords
  end


  def show
    
  end
  def create
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
    @resource=@keyword_page.resources.build(params[:resource])
    @resource.owner=current_user
    if @resource.save
      @keyword_page.updated_at=Time.now
      @keyword_page.save
      n=current_user.news.create
      n.news_type="resource"
      n.owner=current_user
      n.resource=@resource
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
