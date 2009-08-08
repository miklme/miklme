class NewsController < ApplicationController
  before_filter :load_user
  def index
    hot_resources=@user.followings.map do |following|
      following.resources
    end
    @hot_resources=hot_resources.flatten
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end
end
