class UsersController < ApplicationController
  skip_before_filter :login_required,:except=>[:edit,:update,:show]
  skip_before_filter :check_profile_status
  def new
    session[:user_id]=nil
    @user=User.new
  end

  def create
    session[:user_id]=nil
    @user = User.new(params[:user])
    if @user.save
      session[:user_id]=@user.id
      flash[:notice] = "感谢注册，即刻将体验Michael带给您的...无限。"
      redirect_to edit_user_path(current_user)
    else
      render new_user_path,:layout => "users"
    end
  end

  def edit
    @user=User.find(current_user)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to(user_path(@user))
    else
      render :action => "edit",:layout => "users"
    end
  end


  def show
    @user =User.find(params[:id])
    redirect_to user_resources_path(@user)
  end
  def search
    @user=current_user
    if params[:user][:name] and params[:user][:id].blank?
      @users=User.all.find(params[:user]).by_value
    elsif params[:user][:id] and params[:user][:name].blank?
      @users=User.scoped_by_id(params[:user][:id]).first
    end
    render :layout => "news"
  end
end