class KeywordPagesController < ApplicationController
  before_filter :load_user,:only => [:destroy,:create,:update,:edit]
  skip_before_filter :login_required,:only => [:show_hidden,:show,:by_time,:index,:auto_complete_for_keyword_page_keyword,:redirect]
  skip_before_filter :check_profile_status
  def index
    @user=current_user
    if logged_in?
      @keyword_page=@user.keyword_pages.build
    end
    @hot_keyword_pages=KeywordPage.hot_keyword_pages
    @new_keyword_pages=KeywordPage.find(:all,:order => "created_at DESC",:limit => 15)
    @long_name_keyword_pages=KeywordPage.long_name_keyword_pages
    @girls_pages=KeywordPage.girls_pages
    @news=Resource.blog_and_link_url_resources.recent
    gs=KeywordPage.find(:all).map do |k|
      k.top_resource
    end
    gs=gs.compact.sort_by {|g| g.created_at}
    @goods=gs.reverse.first(15)
    render :layout => "related_keywords"
  end
  
  def create
    @keyword_page=KeywordPage.find_or_create_by_keyword(:keyword => params[:keyword_page][:keyword])
    begin
      @user.keyword_pages<<@keyword_page
      if @keyword_page.top_user==current_user
        flash[:notice]="成功。要知道，你是这个”领域“价值点数最高的人。想要让更多人认识到你，你最好让更多人关注你，
      或者是进入该领域页面，编辑“相关领域。”"
      else
        flash[:notice]="创建成功。"
      end
      redirect_to :back
    rescue
      flash[:notice]="出了点小问题，你是这个领域已经存在了，或者你没有填写领域名称。"
      redirect_to :back
    end
  end
   
  
  def show
    @keyword_page=KeywordPage.find(params[:id])
    @resources=@keyword_page.resources_by_value(params[:page])
    @related_keywords=@keyword_page.related_keywords
  end

  def by_time
    @keyword_page=KeywordPage.find(params[:id])
    @resources=@keyword_page.resources_by_time(params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :action => :show
  end

  def hide_field
    v=ValueOrder.find_by_user_id_and_keyword_page_id(current_user.id,params[:id])
    v.hidden=true
    v.save
    redirect_to :back
  end

  def appear_field
    v=ValueOrder.find_by_user_id_and_keyword_page_id(current_user.id,params[:id])
    v.hidden=false
    v.save
    redirect_to :back
  end

  def auto_complete_for_keyword_page_keyword
    keyword_pages=KeywordPage.find_with_ferret(params[:keyword_page][:keyword]+"~")
    @keyword_pages=keyword_pages.first(15)
    render :layout => false
  end

  def redirect
    keyword_page=KeywordPage.find_by_keyword(params[:keyword])
    render :update do |page|
      page.redirect_to keyword_page_path(keyword_page)
    end
  end

  def show_hidden
    render :update do |page|
      page.toggle "hidden"
    end
  end
end
