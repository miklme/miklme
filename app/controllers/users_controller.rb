class UsersController < ApplicationController
  skip_before_filter :login_required
  layout 'sessions',:only =>:new
  
  def new
    @user=User.new
  end

  def create
    session[:user_id]=nil
    @user = User.new(params[:user])
    @user.check_activation_status(params[:user][:email])
    if @user.save
      email=UserMailer.create_activation(@user)
      email.set_content_type('text/html')
      UserMailer.deliver(email)
      flash[:notice] = "感谢注册，你距离Michael只有一步之遥，
    请即刻访问你的邮箱  #{@user.email}，以激活账户。"
      redirect_to new_session_path 
    else
      render new_user_path,:layout=>'sessions'
    end
  end

  def edit
    @user=User.find(params[:id])
  end


  def activate
    session[:user_id]=nil
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    if (!params[:activation_code].blank?) and user and !user.active?
      user.activate!
      flash[:notice] = "激活成功，即刻将体验Michael带给您的...无限。"
      redirect_to edit_user_path(user)
    elsif params[:activation_code].blank?
      flash[:error] = "激活码不存在，请点击邮件中的链接来激活。"
      redirect_to new_session_path
    else
      flash[:error]  = "那个激活码不能激活任何账户——确认电子邮件中的链接是这个吗？
或者你已经激活过了，请登录。"
      redirect_to new_session_path
    end
  end
end
