class UsersController < ApplicationController
  skip_before_filter :login_required,:except=>[:edit,:update,:show]
  skip_before_filter :check_profile_status,:except => :show
  auto_complete_for :keyword_page,:keyword
  def new
    session[:user_id]=nil
    @user=User.new
  end

  def create
    session[:user_id]=nil
    @user = User.new(params[:user])
    if @user.save
      session[:user_id]=@user.id
      flash[:notice] = "感谢注册，即刻体验Michael带给你的..."
      redirect_to edit_user_path(current_user)
    else
      render new_user_path,:layout => "users"
    end
  end

  def edit
    @user=User.find(current_user)
    @keyword_pages=@user.keyword_pages
  end

  def manage_keywords
    render :update do |page|
      page.visual_effect(:appear, "my_keywords")
    end
  end
  
  def update
    @user = User.find(params[:id])
    if  @user.update_attributes(params[:user])
      redirect_to(user_path(@user))
    else
      render :action => "edit"
    end
  end


  def show
    @user=User.find(params[:id])
    @news=News.list_self_news(@user,params[:page])
    @self_news_for_others=News.self_news_for_others(@user,params[:page])
    @variable_title="这里开始..."
    @resources=@user.resources.find(:all,:order => "resources.created_at DESC")
    @twitter_resource=@user.twitter_resources.build
    render :layout => "resources"
  end
  def search
    @user=current_user
    if params[:user][:name] and params[:user][:id].blank?
      @results=User.scoped_by_name(params[:user][:name]).by_total_value
    elsif params[:user][:id] and params[:user][:name].blank?
      @result=User.find_by_id(params[:user][:id])
    end
    render :layout => "news"
  end
end