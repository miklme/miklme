class ResourcesController < ApplicationController
  skip_before_filter :login_required,:except => [:new,:create]
  caches_page :preview,:origin
  def new

  end


  def preview
    @resource=Resource.find(params[:id])
    respond_to do |format|
      format.jpg
    end
  end

  def origin
    @resource=Resource.find(params[:id])
    respond_to do |format|
      format.jpg
    end
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
      redirect_to keyword_page_path(@keyword_page)
    else
      render :action => :new,:layout => "keyword_pages"
    end
  end

end
