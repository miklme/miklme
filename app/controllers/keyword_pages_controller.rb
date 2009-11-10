class KeywordPagesController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :check_profile_status
  def index
    @user=current_user
    @recent_keyword_pages=KeywordPage.recent_keyword_pages
    @top_users=User.top_10
    @many_user_keyword_pages=KeywordPage.active_user_keyword_pages.first(5)
    render :layout => "related_keywords"
  end
  
  def create
    @keyword_page=KeywordPage.find_or_create_by_keyword(params[:keyword_page][:keyword])
    if logged_in? and !current_user.keyword_pages.include?(@keyword_page)
      current_user.keyword_pages<<@keyword_page
    end
    redirect_to keyword_page_path(@keyword_page)
  end
   
  
  def show
    @keyword_page=KeywordPage.find(params[:id])
    if logged_in? and !current_user.keyword_pages.include?(@keyword_page)
      current_user.keyword_pages<<@keyword_page
    end
    if logged_in?
      @user=current_user
      @news=News.list_self_news(@user)
      @resource=@keyword_page.resources.build
    end
    @users=@keyword_page.users_have_resources.paginate(:page => params[:page],:per_page => 10)
    keyword_pages=KeywordPage.find_with_ferret(@keyword_page.keyword+"~")-@keyword_page.to_a
    @searched_keywords=keyword_pages.find_all{|k| k.resources.size>=1}.first(10)
    #未使用用户自定义编辑贴吧功能
    @related_keywords=@keyword_page.related_keywords
  end

  def by_time
    @keyword_page=KeywordPage.find(params[:id])
    if logged_in?
      @user=current_user
      @resource=@keyword_page.resources.build
    end
    @resources=@keyword_page.resources.find(:all,:limit => 40,:order => "created_at DESC")
    @related_keywords=@keyword_page.related_keywords
    render :update do |page|
      page.replace "wg0",:partial => "by_time"
    end
  end


  def more
    if flash["resource_offset_of_#{params[:user_id]}"].blank?
      flash["resource_offset_of_#{params[:user_id]}"]=4
    else
      flash["resource_offset_of_#{params[:user_id]}"]+=10
    end
    k=KeywordPage.find(params[:keyword_page_id])
    resources=User.find(params[:user_id]).resources.find(:all,:limit => 10,:offset => flash["resource_offset_of_#{params[:user_id]}"],:order => "created_at DESC",:conditions => {:keyword_page_id => k.id})
    render :update do |page|
      page.insert_html :before,"more_of_#{params[:user_id]}",:partial => "resources/no_profile_resource",:collection => resources
    end
  end

  

  def more_pages
    if flash[:keyword_page_offset].blank?
      flash[:keyword_page_offset]=5
    else
      flash[:keyword_page_offset]+=5
    end
    @keyword_pages=KeywordPage.active_user_keyword_pages[(flash[:keyword_page_offset])..(flash[:keyword_page_offset]+4)]
    render :update do |page|
      page.insert_html :before,"more_pages",:partial => "keyword_page_index",:collection => @keyword_pages
    end
  end
end
