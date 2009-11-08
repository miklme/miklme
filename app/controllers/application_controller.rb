# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required,:check_profile_status

  def auto_complete_for_keyword_page_keyword
    keyword_pages=KeywordPage.find_with_ferret(params[:keyword_page][:keyword]+"~")
    @keyword_pages=keyword_pages.find_all{|k| k.resources.size>=1}.first(15)
    render :layout => false
  end
  
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

  def cheat_validation(comment)
    ips=comment.resource.keyword_page.users.map do |user|
      user.last_ip
    end
    if ips.find_all{|ip| ip==current_user.last_ip}.size==1 and\
        comment.resource.commenters.find_all{|object| object.id==current_user.id}.size==1 and\
        comment.resource.owner!=current_user
      true
    else
      comment.rating=0
      comment.save
      false
    end
  end

  def cheat_validation_2(comment_comment)
    ips=comment_comment.resource.keyword_page.users.map do |user|
      user.last_ip
    end
    commenters=comment_comment.parent_comment.commenters
    if ips.find_all{|ip| ip==current_user.last_ip}.size==1 \
        and commenters.find_all{|object| object.id==current_user.id}.size==1\
        and comment_comment.parent_comment.owner!=current_user
      true
    else
      comment_comment.rating=0
      comment_comment.save
      false
    end
  end

  def calculate_comment_value(comment)
    object=comment.parent.owner
    a=choose_validater(comment)
    if a
      current_v=current_user.field_value(comment.resource.keyword_page)
      author_v=object.field_value(comment.resource.keyword_page)
      if current_v<= author_v and comment.rating==-1
        object.change_value comment.resource.keyword_page,-comment.resource.keyword_page.lower_higher_bad(comment.parent)
        object.save
      elsif current_v>author_v and comment.rating==-1
        object.change_value(comment.resource.keyword_page,-comment.resource.keyword_page.higher_lower_bad(comment.parent.owner))
        object.save
      elsif comment.rating==1 and  current_v>author_v
        object.change_value comment.resource.keyword_page,comment.resource.keyword_page.higher_lower_good(current_user,comment.parent.owner)
        object.save
      elsif comment.rating==1 and  current_v<=author_v
        object.change_value comment.resource.keyword_page,comment.resource.keyword_page.lower_higher_good(comment.parent)
        object.save
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

  def toggle_blind
    render :update do |page|
      page.visual_effect :toggle_blind,params[:id]
    end
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end

  
end
