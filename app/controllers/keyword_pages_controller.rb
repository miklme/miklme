class KeywordPagesController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :check_profile_status
  def index
    @user=current_user
    @news=News.list_self_news(@user) if logged_in?
    @many_user_keyword_pages=KeywordPage.find(:all).find_all{|page| page.users_have_resources.size>=3}.sort_by{|page| page.updated_at}.reverse.first(15)
    @friends_news=News.list_friends_news(@user,0) if logged_in?
    render :layout => "related_keywords"
  end

  def friends
  end
  
  def create
    begin
      @keyword_page=KeywordPage.find_or_create_by_keyword(params[:keyword_page][:keyword])
      if logged_in? and !current_user.keyword_pages.include?(@keyword_page)
        current_user.keyword_pages<<@keyword_page
      end
      redirect_to keyword_page_path(@keyword_page)
    end
  rescue
    redirect_to :back
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
    @per_page=10
    @users=@keyword_page.users_have_resources.paginate(:page => params[:page],:per_page => @per_page)
    session[:page]=params[:page]
    keyword_pages=KeywordPage.find_with_ferret(@keyword_page.keyword+"~")-@keyword_page.to_a
    @searched_keywords=keyword_pages.find_all{|k| k.resources.size>=1}.first(8)
    #未使用用户自定义编辑关键字功能
    @related_keywords=@keyword_page.related_keywords
  end


  def more
    if flash["resource_offset_of_#{params[:user_id]}"].blank?
      flash["resource_offset_of_#{params[:user_id]}"]=1
    else
      flash["resource_offset_of_#{params[:user_id]}"]+=10
    end
    k=KeywordPage.find(params[:keyword_page_id])
    resources=User.find(params[:user_id]).resources.find(:all,:limit => 10,:offset => flash["resource_offset_of_#{params[:user_id]}"],:order => "created_at DESC",:conditions => {:keyword_page_id => k.id})
    render :update do |page|
      page.insert_html :before,"more_of_#{params[:user_id]}",:partial => "resources/resource_right",:collection => resources
    end
  end

  def more_friends_news
    if flash[:friends_news_offset].blank?
      flash[:friends_news_offset]=20
    else
      flash[:friends_news_offset]+=20
    end
    @friends_news=News.list_friends_news(current_user,flash[:friends_news_offset])
    render :update do |page|
      page.insert_html :bottom,"wg0",:partial => "news/friends_news",:collection => @friends_news
    end
  end

end
