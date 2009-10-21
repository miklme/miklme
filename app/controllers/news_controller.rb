class NewsController < ApplicationController
  before_filter :load_user
  def index
    @others_news=News.list_friends_news(@user,params[:page])
    @followings = @user.followings
    @followers=@user.followers
  end

  def show
    keyword_page_news=News.find(params[:id])
    redirect_to user_resource_comments_path(keyword_page_news.resource.owner,keyword_page_news.resource)
    if keyword_page_news.owner==current_user
      keyword_page_news.destroy
    end
  end
end
