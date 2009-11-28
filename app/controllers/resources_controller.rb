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
      News.create_resource_news(@resource)
      flash[:notice]="成功。你和你的发言出现在下方的某个位置（取决于你的<cite>生命值</cite>）。"
      redirect_to keyword_page_path(@keyword_page)
    else
      render :action => :new,:layout => "keyword_pages"
    end
  end

end
