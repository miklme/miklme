class NewsController < ApplicationController
  before_filter :load_user

  def show
    keyword_page_news=News.find(params[:id])
    if keyword_page_news.news_type=="be_comment"
      redirect_to user_resource_comments_path(keyword_page_news.resource.owner,keyword_page_news.resource)
    elsif keyword_page_news.news_type=="be_follow"
      redirect_to user_path(keyword_page_news.follower)
    end
    if keyword_page_news.owner==current_user
      keyword_page_news.destroy
    end
  end

end
