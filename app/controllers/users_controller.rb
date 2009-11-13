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
    session[:value_order_id]=params[:value_order_id]
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

  def edit_ajax
    
  end
  def manage_keywords
    render :update do |page|
      page.visual_effect(:appear, "my_keywords")
    end
  end
  
  def update
    @user = User.find(params[:id])
    if  @user.update_attributes(params[:user])
      if session[:inviter_id].present? and @user.last_ip!=User.find(session[:inviter_id]).last_ip
        b=BeFollow.new
        b.user=User.find(session[:inviter_id])
        b.follower=current_user
        v=ValueOrder.find(session[:value_order_id])
        v.value+=1.0
        v.save
        b.save
        flash[:notice]="你关注了#{User.find(session[:inviter_id]).name_or_nick_name(current_user)}"
        session[:relationship]=session[:inviter_id]=session[:value_order_id]=nil
      end
      flash[:notice]="你终于注册成功了。"
      redirect_to keyword_pages_path
    else
      render :action => "edit"
    end
  end


  def show
    @user=User.find(params[:id])
    @news=News.self_news_for_others(@user,params[:page])
    @friends_news=News.list_friends_news(@user)
    render :layout => "resources"
  end
  def search
    @user=current_user
    if params[:user][:name] and params[:user][:id].blank?
      @results=User.scoped_by_name(params[:user][:name])
    elsif params[:user][:id] and params[:user][:name].blank?
      @result=User.find_by_id(params[:user][:id])
    end
    render :layout => "news"
  end
end