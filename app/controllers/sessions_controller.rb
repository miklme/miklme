# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
     if logged_in?
      redirect_to new_user_searched_keyword_path(current_user)
    end
    @user=User.new
  end

  def create
    session[:user_id]=nil
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      new_cookie_flag
      redirect_to new_user_searched_keyword_path(current_user)
      flash[:notice] = "成功登入，即刻将体验Michael带给你的...无限"
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    session[:user_id]=nil
    flash[:notice] = "成功离开Michael"
    redirect_to new_session_path
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "恩...出了点小问题，检查一下是否邮箱名和密码有错误."
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end

end
