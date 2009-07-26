class BlogResourcesController < ApplicationController
  before_filter :find_user
  def new
  end

  def show
  end

  def edit
  end

  def index
    @blog_resources=@user.blog_resources
  end

  private
  def find_user
    @user=User.find(params[:user_id])
  end
end
