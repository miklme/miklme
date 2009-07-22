# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_required
  
  def login_required
    if not logged_in?
      flash[:notice]='请登录以继续...'
      redirect_to new_session_path
    end
  end

  def check_resource_type(content)
    if content=~/[a-zA-z]/
      "link_url_resource"
    elsif !content=~/[a-zA-z]/ and content.count<=139
      "twitter_resource"
    elsif  !content=~/[a-zA-z]/ and content.count>=140
      "blog_resource"
    end
  end
end
