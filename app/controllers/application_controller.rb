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
    if content =~ %r{[a-zA-z]+://[^\s]*}
      "link_url_resource"
    elsif content !~%r{[a-zA-z]+://[^\s]*} and content.length<=139
      "twitter_resource"
    elsif  content !~%r{[a-zA-z]+://[^\s]*} and content.length>=140
      "blog_resource"
    end
  end

  def check_content
    @resource = current_user.resources.build
    check_result=check_resource_type(params[:resource][:step_one])
    if check_result=="link_url_resource"
      @known_resource= Resource.scoped_by_link_url(params[:resource][:step_one]).by_owner_value.first
      @resource.link_url=params[:resource][:step_one]
      @resource.resource_type="link_url_resource"
      flash[:link_url]=params[:resource][:step_one]
      render :update do |page|
        page.replace_html 'new_resource',:partial => "link_url_resource"
      end
    elsif check_result=="twitter_resource"
      @resource.resource_type="twitter_resource"
      @resource.keywords=params[:resource][:step_one]
      @resource.save!
      render :update do |page|
        page.replace_html "new_resource",:partial => "twitter_resource"
        page.insert_html :top,"r",:partial => "resource",:object => @resource
      end
    elsif check_result=="blog_resource"
      render :update do |page|

      end
    end
  end
  
end
