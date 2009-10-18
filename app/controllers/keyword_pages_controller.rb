class KeywordPagesController < ApplicationController
  skip_before_filter :login_required,:except => [:create]
  skip_before_filter :check_profile_status
  def index
    @user=current_user
    if logged_in?
      @keyword_page=@user.keyword_pages.build
    end
    @recent_resources=BlogResource.find(:all,:limit => 40,:order => "created_at DESC")
    @hot_keyword_pages=KeywordPage.hot_keyword_pages
    @new_keyword_pages=KeywordPage.find(:all,:order => "created_at DESC",:limit => 15)
    @many_resources_keyword_pages=KeywordPage.many_resources_keyword_pages
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
    @keyword_page=KeywordPage.new(params[:keyword_page])
    if @keyword_page.save
      v=ValueOrder.new
      v.keyword_page=@keyword_page
      v.user=current_user
      v.actived=true
      v.save
      flash[:notice]="创建成功。在这个关键字内你的初始声望为0"
      redirect_to keyword_page_path(@keyword_page)
    else
      render :action => :index,:layout => "related_keywords"
    end
  end
   
  
  def show
    @keyword_page=KeywordPage.find(params[:id])
    if logged_in?
      @user=current_user
      @news=News.list_self_news_2(@user)
      @blog_resource=@keyword_page.blog_resources.build
    end
    @resources=@keyword_page.resources
    ids=@resources.map do |r|
      r.user_id
    end
    ids.uniq!
    @user_s=User.find(ids).sort_by { |u| [u.field_value(@keyword_page),u.created_at]}
    @users=@user_s.reverse.paginate(:page => params[:page],:per_page => 10)
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

  
  def more
    k=KeywordPage.find(params[:keyword_page_id])
    resources=User.find(params[:id]).resources.find(:all,:limit => 38,:offset => 5,:order => "created_at DESC",:conditions => {:keyword_page_id => k.id})
    ids=resources.map do |r|
      "hidden_"+r.id.to_s
    end
    render :update do |page|
      for i in ids
        page.visual_effect :toggle_blind,i
      end
    end
  end

end
