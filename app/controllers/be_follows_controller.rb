class BeFollowsController < ApplicationController
  before_filter :load_user  # GET /be_follows.xml
  layout "news"

  def new
    @be_follow=@user.be_follows.build
    @follow=current_user.follows.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @follows }
    end
  end
  def index
    @followers = @user.followers

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @be_follows }
    end
  end

  # GET /be_follows/1
  # GET /be_follows/1.xml
  def show
    @be_follow = BeFollow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @be_follow }
    end
  end

  def edit
    @be_follow = BeFollow.find(params[:id])
  end

  # POST /be_follows
  # POST /be_follows.xml
  def create
    @be_follow = @user.be_follows.build(params[:be_follow])
    @be_follow.user=@user
    @be_follow.follower=current_user
    @follow=current_user.follows.build(params[:be_follow])
    @follow.user=current_user
    @follow.following=@user
    respond_to do |format|
      if @be_follow.save
        @follow.save
        flash[:notice] = '成功关注该用户，之后你会自动获得该用户的一些信息'
        format.html { redirect_to :back }
        format.xml  { render :xml => @be_follow, :status => :created, :location => @be_follow }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @be_follow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /be_follows/1
  # PUT /be_follows/1.xml
  def update
    @be_follow = BeFollow.find(params[:id])

    respond_to do |format|
      if @be_follow.update_attributes(params[:be_follow])
        flash[:notice] = 'BeFollow was successfully updated.'
        format.html { redirect_to(@be_follow) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @be_follow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /be_follows/1
  # DELETE /be_follows/1.xml
  def destroy
    @be_follow = BeFollow.find(params[:id])
    @be_follow.destroy

    respond_to do |format|
      format.html { redirect_to(be_follows_url) }
      format.xml  { head :ok }
    end
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end
end
