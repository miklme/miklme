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
      v.user=@user
      v.actived=true
      v.save
      flash[:notice]="创建成功。在这个领域内你的初始经验值为0"
      redirect_to keyword_page_path(@keyword_page)
    else
      render :action => :index,:layout => "related_keywords"
    end
  end
   
  
  def show
    if logged_in?
      @user=current_user
      @blog_resource=current_user.blog_resources.build
    end
    @keyword_page=KeywordPage.find(params[:id])
    session[:current_keyword_page_id]=(params[:id])
    @resources=@keyword_page.resources
    ids=@resources.map do |r|
      r.user_id
    end
    ids.uniq!
    @related_keywords=@keyword_page.related_keywords
    @users=User.find(ids).paginate(:page => params[:page],:per_page => 10)
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
      page.visual_effect :toggle_slide,"hidden"
    end
  end
  def more
    k=KeywordPage.find(session[:current_keyword_page_id])
    resources=User.find(params[:id]).resources.find(:all,:limit => 23,:offset => 3,:order => "created_at DESC",:conditions => {:keyword_page_id => k.id})
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
