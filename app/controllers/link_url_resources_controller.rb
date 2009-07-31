class LinkUrlResourcesController < ApplicationController
  before_filter :find_user
  auto_complete_for :resource,:keywords
  def new
    @link_url_resource=@user.link_url_resources.build
  end

  def show
  end

  def edit
  end

  def index
    @link_url_resources=@user.link_url_resources
  end
  
  def create
    @link_url_resource=current_user.link_url_resources.build(params[:link_url_resource])
    if @link_url_resource.save
      @link_url_resource.create_keyword_page(:keyword => @link_url_resource.keywords)
      redirect_to user_path(current_user)
    else
      render :action => :new
    end
  end
  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
