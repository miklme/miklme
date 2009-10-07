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
    @keyword_page=KeywordPage.find_by_keyword(params[:keyword_page][:keyword])
    if @keyword_page.present?
      flash[:notice]="出了点小问题，这个领域已经存在"
      redirect_to :back
    else
      k=KeywordPage.create(:keyword => params[:keyword_page][:keyword])
      v=ValueOrder.new
      v.value=3
      v.user=@user
      v.keyword_page=k
      v.actived=true
      v.save
      flash[:notice]="创建成功。由于你是创建者，你拥有3点经验值，而新加入者为0。"
      redirect_to keyword_page_path(k)
    end

  end
   
  
  def show
    if logged_in?
      @user=current_user
      @blog_resource=current_user.blog_resources.build
    end
    @keyword_page=KeywordPage.find(params[:id])
    session[:current_keyword_page_id]=(params[:id])
    @resources=@keyword_page.resources_by_value(params[:page])
    @related_keywords=@keyword_page.related_keywords
  end

  def by_time
    if logged_in?
      @user=current_user
      @blog_resource=current_user.blog_resources.build
    end
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
