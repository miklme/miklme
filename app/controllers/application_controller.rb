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

  def cheat_validation(comment)
    ips=comment.resource.keyword_page.users.map do |user|
      user.last_ip
    end
    if ips.find_all{|ip| ip==current_user.last_ip}.size==1 and\
        comment.resource.commenters.find_all{|u| u.id==current_user.id}.size==1 and\
        comment.resource.owner!=current_user
      true
    else
      comment.rating=0
      comment.save
      false
    end
  end

  def cheat_validation_2(replied_comment)
    ips=replied_comment.resource.keyword_page.users.map do |user|
      user.last_ip
    end
    replied_commenters=replied_comment.parent_comment.replied_comments.map {|r| r.owner}
#    if ips.find_all{|ip| ip==current_user.last_ip}.size==1 \
        if replied_commenters.find_all{|u| u.id==current_user.id}.size==1\
        and replied_comment.parent_comment.owner!=current_user
      true
    else
      replied_comment.rating=0
      replied_comment.save
      false
    end
  end

  def calculate_comment_value(comment)
    u=User.find(comment.resource.owner)
    a=choose_validater(comment)
    if a
      current_v=current_user.field_value(comment.resource.keyword_page)
      author_v=comment.parent.owner.field_value(comment.resource.keyword_page)
      if current_v<= author_v and comment.rating==-1
        u.change_value comment.resource.keyword_page,-comment.resource.keyword_page.lower_higher_bad(comment.parent)
        u.save
      elsif current_v>author_v and comment.rating==-1
        u.change_value(comment.resource.keyword_page,-comment.resource.keyword_page.higher_lower_bad(comment.parent.owner))
        u.save
      elsif comment.rating==1 and  current_v>author_v
        u.change_value comment.resource.keyword_page,comment.resource.keyword_page.higher_lower_good(current_user,comment.parent.owner)
        u.save
      elsif comment.rating==1 and  current_v<=author_v
        u.change_value comment.resource.keyword_page,comment.resource.keyword_page.lower_higher_good(comment.parent)
        u.save
      end
    end
  end

  def choose_validater(comment)
    if comment.parent_comment.present?
      cheat_validation_2(comment)
    else
      cheat_validation(comment)
    end
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end

  
end
