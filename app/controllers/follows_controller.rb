class FollowsController < ApplicationController
  before_filter :load_user
  layout "news"
  # GET /follows
  # GET /follows.xml
  def index
    @real_friends = @user.real_friends
    @interested_people=@user.interested_people
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @follows }
    end
  end



  def search_user

  end

  private
  def load_user
    @user=User.find(params[:user_id])
  end
end
