class KeywordPagesController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :check_profile_status
  def index
    session[:offset]=nil
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
      @blog_resource=@keyword_page.blog_resources.build
    end
    @users=@keyword_page.users_have_resources.paginate(:page => params[:page],:per_page => 10)
    @related_keywords=@keyword_page.related_keywords
  end

  def by_time
    @keyword_page=KeywordPage.find(params[:id])
    if logged_in?
      @user=current_user
      @blog_resource=@keyword_page.blog_resources.build
    end
    @resources=@keyword_page.resources.find(:all,:limit => 40,:order => "created_at DESC")
    @related_keywords=@keyword_page.related_keywords
    render :update do |page|
      page.replace "wg0",:partial => "by_time"
    end
  end


  def more
    k=KeywordPage.find(params[:keyword_page_id])
    resources=User.find(params[:id]).resources.find(:all,:limit => 38,:offset => 4,:order => "created_at DESC",:conditions => {:keyword_page_id => k.id})
    ids=resources.map do |r|
      "hidden_"+r.id.to_s
    end
    render :update do |page|
      for i in ids
        page.visual_effect :toggle_blind,i
      end
    end
  end

  

  def more_pages
    if session[:offset].blank?
      session[:offset]=5
    else
      session[:offset]+=5
    end
    @keyword_pages=KeywordPage.active_user_keyword_pages[(session[:offset])..(session[:offset]+4)]
    render :update do |page|
      page.insert_html :before,"more_pages",:partial => "keyword_page_index",:collection => @keyword_pages
    end
  end
end
