class NewsController < ApplicationController
  before_filter :load_user
  def index
    @others_news=News.list_others_news(@user,params[:page])
    @real_friends = @user.real_friends
    @interested_people=@user.interested_people
  end

end
