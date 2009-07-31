class NewsController < ApplicationController
  before_filter :load_user
  def index
    @hot_resources=@user.followings.map do |following|
      following.resources.hot_resources
    end
  end
  private
  def load_user
    @user=current_user
  end
end
