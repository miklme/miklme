class NewsController < ApplicationController
  before_filter :load_user
  def index
    @others_news=News.list_others_news(@user,params[:page])
    @followings = @user.followings
    @followings=@user.followings
  end

end
