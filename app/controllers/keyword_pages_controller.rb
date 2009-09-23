class KeywordPagesController < ApplicationController
  before_filter :load_user,:only => [:new,:destroy,:create,:update,:edit]
  skip_before_filter :login_required,:only => [:show,:by_time,:index]
  skip_before_filter :check_profile_status
  auto_complete_for :keyword_page,:keyword,:limit => 10

  def new
    @keyword_page=@user.keyword_pages.build
    render :layout => "related_keywords"
  end

  def index
    render :layout => "related_keywords"
  end
  
  def destroy
    keyword_page=@user.keyword_pages.find(params[:id])
    keyword_page.destroy
    redirect_to :back
  end

  def create
    @keyword_page=KeywordPage.find_or_create_by_keyword(:keyword => params[:keyword_page][:keyword])
    begin
      @user.keyword_pages<<@keyword_page
      if @keyword_page.top_user==current_user
        flash[:notice]="成功。要知道，你是这个”领域“价值点数最高的人。想要让更多人认识到你，你最好让更多人关注你，
      或者是进入该领域页面，编辑“相关领域。”"
      else
        flash[:notice]="成功。要查看该领域内容，可以点击'Mikl'链接"
      end
      redirect_to :back
    rescue
      flash[:notice]="出了点小问题，你已经进入该领域了，或者你没有填写名称。"
      redirect_to :back
    end
  end
  
  def show
    @keyword_page=KeywordPage.find(params[:id])
    @resources=@keyword_page.resources_by_value(params[:page])
    @related_keywords=@keyword_page.related_keywords
    flash[:keyword]="这个是关于“#{@keyword_page.keyword}”的页面,若想要在本页面中增加条目，需要在“领域”中选择“#{@keyword_page.keyword}”
    ，所以首先你要将这个领域添加进'我的领域'"
  end

  def by_time
    @keyword_page=KeywordPage.find(params[:id])
    @resources=@keyword_page.resources_by_time(params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :action => :show
  end

end
