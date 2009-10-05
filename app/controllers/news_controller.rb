class NewsController < ApplicationController
  before_filter :load_user
  def index
    @others_news=News.list_friends_news(@user,params[:page])
    @followings = @user.followings
    @followers=@user.followers
  end

end
