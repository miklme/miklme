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
      flash[:error]='请登录以继续...'
      redirect_to :back
    end
  end
  def check_profile_status
    if logged_in?
      if current_user.nick_name.blank? or current_user.city.blank?
        redirect_to edit_user_path(current_user)
        flash[:notice]="完善你的个人资料，否则你什么都干不了"
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
    if ips.find_all{|ip| ip==current_user.last_ip}.size==1 and\
        commenters.find_all{|object| object.id==current_user.id}.size==1 and\
        comment_comment.parent_comment.owner!=current_user
      true
    else
      comment_comment.rating=0
      comment_comment.save
      false
    end
  end
  def good_comment(user1,user2)
    ((user1.value-user2.value)/2).abs
  end

  def bad_comment(user1,user2)
    (user1.value-user2.value).abs
  end
  
  def change_user_value(comment)
    object=comment.parent.owner
    a=choose_validater(comment)
    if a
      current_v=current_user.value
      author_v=object.value
      if current_v<author_v and comment.rating==-1
        current_user.value+=(-bad_comment(current_user,object))
        current_user.save
      elsif current_v>author_v and comment.rating==-1
        object.value+=(-bad_comment(current_user,object))
        object.save
      elsif comment.rating==1 and  current_v>author_v
        object.value+=(good_comment(current_user,object))
        object.save
      elsif comment.rating==1 and  current_v<author_v
        current_user.value+=(good_comment(current_user,object))
        current_user.save
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

  def comment_notice(comment)
    k=comment.resource.keyword_page
    #自己比别人差，并差评别人
    if comment.changed_value<0 and comment.rating<0
      "你试图攻击#{comment.parent.owner.nick_name}，可是对方生命值比你高，你被反弹，生命值<cite>#{comment.changed_value}</cite>"
      #比别人差，但支持别人
    elsif comment.changed_value<0 and comment.rating>0
      "他的生命值比你高，你借了光，生命值增加<cite>#{comment.changed_value.abs/2}</cite>"
      #比别人好，支持别人
    elsif comment.changed_value>0 and comment.rating>0
      "你鼓励了后生。后生的生命值增加<cite>#{comment.changed_value.abs/2}</cite>"
      #比别人强，反驳对方
    elsif comment.changed_value>0 and comment.rating<0
      "身为长辈的你打击了后生，后生的生命值大降<cite>#{comment.changed_value.abs}</cite>"
      #不表态
    elsif comment.rating==0
      "面无表情的你回应成功"
    end
  end

  def same_ip_validation(user1,user2)
    if user1.last_ip!=user2.last_ip
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
