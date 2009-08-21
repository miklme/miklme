class NewsController < ApplicationController
  before_filter :load_user
  def index
   n=@user.followings.map do |following|
      following.news
    end
    @news=n.flatten
  end

  private
  def load_user
    @user=User.find(params[:user_id])
  end
end
