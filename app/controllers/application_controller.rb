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
        flash[:notice]="为了更好的体验Michael.me的服务，请您完善个人资料。"
      end
    end
  end

  def next_step
    render :update do |page|
      page.hide "show"
      page.show "hide"
    end
  end

  def show_hidden
    render :update do |page|
      page.toggle "hidden"
    end
  end

  def comment_validation(comment)
    u=User.find(comment.resource.owner)
    if u!=current_user and comment.resource.commenters.find(:all,current_user.id).size==1 and comment.resource.owner.last_ip!=current_user.last_ip
      true
    else
      false
    end
  end

  def lower_higher_good_validation(comment)
    if comment.content.length>=6
      true
    else
      false
    end
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end

end
