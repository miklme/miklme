class NewsController < ApplicationController
  before_filter :load_user
  def index
    @others_news=News.list_others_news(@user,params[:page])
  end

  private
  def load_user
    @user=User.find(params[:user_id])
  end
end
