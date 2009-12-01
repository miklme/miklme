class UsersController < ApplicationController
  skip_before_filter :login_required,:except=>[:edit,:update,:show]
  skip_before_filter :check_profile_status,:except => :show
  auto_complete_for :keyword_page,:keyword
  def new
    session[:user_id]=nil
    @user=User.new
  end

  def invite
    session[:user_id]=nil
    @user=User.new
    session[:inviter_id]=params[:inviter_id]
    render :action => :new
  end
  
  def create
    session[:user_id]=nil
    @user = User.new(params[:user])
    if @user.save
      session[:user_id]=@user.id
      flash[:notice] = "完善一下资料，要不然你还是什么都干不了。"
      current_user.last_ip=request.remote_ip
      current_user.save
      redirect_to edit_user_path(current_user)
    else
      render :action => :new
    end
  end

  def edit
    @user=User.find(current_user)
  end

  def update
    @user = User.find(params[:id])
    if  @user.update_attributes(params[:user])
      if session[:inviter_id].present?  and same_ip_validation(@user,User.find(session[:inviter_id]))
        b=BeFollow.new
        b.user=User.find(session[:inviter_id])
        b.follower=current_user
        b.save
        flash[:notice]="你现在关注了#{User.find(session[:inviter_id]).name_or_nick_name(current_user)}。在你关注一个人之后，首页里就会显示他的最新动态。"
        session[:relationship]=session[:inviter_id]=nil
      end
      flash[:notice]="你终于注册成功了。在开始之前，请按照说明一步步来。"
      redirect_to keyword_pages_path
    else
      render :action => "edit"
    end
  end


  def show
    @user=User.find(params[:id])
    @be_follow=BeFollow.new
    @news=News.self_news_for_others(@user,params[:page])
    @friends_news=News.list_friends_news(@user,0)
    render :layout => "resources"
  end
  def search
    @user=current_user
    by_name=User.find_all_by_name(params[:user][:name])
    by_nick_name=User.find_all_by_nick_name(params[:user][:name])
    by_id=User.find_all_by_id(params[:user][:name])
    @results=(by_name+by_nick_name+by_id).uniq
    render :layout => "news"
  end

end