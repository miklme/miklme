class FollowsController < ApplicationController
  before_filter :load_user
  layout "news"
  # GET /follows
  # GET /follows.xml
  def index
    @followings = @user.followings
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @follows }
    end
  end
end
