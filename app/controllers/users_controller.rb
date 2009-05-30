class UsersController < ApplicationController
  skip_before_filter :login_required

  def new
    @user=User.new
  end
 
  def create
   
    #logout_keeping_session!
    @user = User.new(params[:user])
    success = @user and @user.save
    if success and @user.errors.empty?
      flash[:notice] = "感谢注册，你距离Michael只有一步之遥，
      请访问你的邮箱，以激活账户。"
    else
      flash[:error]  = "请确保你输入的项目准确无误。"
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "注册成功，即刻你将体验到Michael带给您的...无限。"
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
