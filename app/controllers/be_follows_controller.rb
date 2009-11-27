class BeFollowsController < ApplicationController
  before_filter :load_user  # GET /be_follows.xml
  layout "news"

  def index
    @be_follow=BeFollow.new
    @be_follows=@user.be_follows
    @followers=@user.followers
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @be_follows }
    end
  end

  def create
    user=User.find(params[:user_id])
    @be_follow = BeFollow.new
    @be_follow.user=user
    @be_follow.follower=current_user
    if @be_follow.save
      n=user.news.create
      n.owner=user
      n.follower_id=current_user.id
      n.news_type="be_follow"
      n.save
      redirect_to :back
    else
      redirect_to :back
    end
  end

  def destroy
    @be_follow = BeFollow.find(params[:id])
    @be_follow.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.xml  { head :ok }
    end
  end

end
