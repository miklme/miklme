# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required,:check_profile_status

  def login_required
    if not logged_in?
      flash[:notice]='请登录以继续...'
      redirect_to new_session_path
    end
  end
  def check_profile_status
    if logged_in?
      if current_user.name.blank? or current_user.nick_name.blank?
        redirect_to edit_user_path(current_user)
        flash[:notice]="为了更好的体验Mikl.me的服务，请您完善个人资料。"
      end
    end
  end

  def next_step
    render :update do |page|
      page.hide "show"
      page.show "hide"
    end
  end

  def comment_value(keyword_page)
    current_user.field_value(keyword_page)/10+0.5
    
  end
  
  private
  def load_user
      @user=User.find(params[:user_id])
  end
end
