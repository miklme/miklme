class LinkUrlResourcesController < ApplicationController
  before_filter :find_user
  def new
  end

  def show
  end

  def edit
  end

  def index
    @link_url_resources=@user.link_url_resources
  end
  
  def create
    @link_url_resource=current_user.resources.build
    if !params[:resource][:title].blank? and !params[:resource][:keywords].blank? and !flash[:link_url].blank?
      @link_url_resource.update_attributes(:type => "link_url_resource",:title=>params[:title], :keywords=>params[:keywords],:link_url => flash[:link_url])
      @link_url_resource.save
      render :update do |page|
        page.redirect_to user_path(current_user)
      end
    else
      render :update do |page|
        page.insert_html :top, "new_resource", "<p>请填写完全</p>"
      end
    end
  end
  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
