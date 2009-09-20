# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def via_keyword_to_keyword_page(keywords)
    KeywordPage.find_by_keyword(keywords)
  end

  def link_to_follower(id)
    User.find(id)
  end

  def link_to_value_help
    link_to "总价值点数[?]",{:controller => :shared,:action => :value},:popup => ['关于价值点数', 'height=300,width=600']
  end

  def link_to_me
    if logged_in?
      link_to ".Me",user_path(current_user)
    else
      flash[:notice]='请登录以继续...'
      link_to ".Me",new_session_path
    end
  end
end
