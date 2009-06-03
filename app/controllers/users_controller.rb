class UsersController < ApplicationController
  skip_before_filter :login_required

  def new
    @user=User.new
  end

  def create
    #logout_keeping_session!
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(@user) }
        email=UserMailer.create_activation(@user)
        email.set_content_type('text/html')
        UserMailer.deliver(email)
      else
        format.html { render :controller=>:sessions,:action=>:new }
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
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
end
