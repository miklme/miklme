class UsersController < ApplicationController
  skip_before_filter :login_required
  layout 'sessions'
  def new
    @user=User.new
  end

  def create
    session[:user_id]=nil
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = "感谢注册，你距离Michael只有一步之遥，
    请访问你的邮箱#{@user.email}，以激活账户。"
        format.html { redirect_to new_session_path }
        email=UserMailer.create_activation(@user)
        email.set_content_type('text/html')
        UserMailer.deliver(email)
      else
        format.html { render new_user_path,:layout=>'sessions' }
      end
    end
     
  end


  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "注册成功，即刻将体验Michael带给您的...无限。"
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "激活码不存在，请点击邮件中的链接来激活。"
      redirect_back_or_default('/')
    else
      flash[:error]  = "那个激活码不能激活任何账户——确认电子邮件中的链接是这个吗？
或者你已经激活过了，请登录。"
      redirect_back_or_default('/')
    end
  end
end
