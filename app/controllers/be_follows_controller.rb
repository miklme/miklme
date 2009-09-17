class BeFollowsController < ApplicationController
  before_filter :load_user  # GET /be_follows.xml
  layout "news"

  def new
    @be_follow=BeFollow.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @follows }
    end
  end
  def index
    @be_follows=@user.be_follows
    @followers=@user.followers
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
    @be_follow = BeFollow.new(params[:be_follow])
    @be_follow.user=@user
    @be_follow.follower=current_user
    respond_to do |format|
      if @be_follow.save
        @user.value=@user.value+3
        @user.save
        n=@user.news.create
        n.owner=@user
        n.follower_id=current_user.id
        if @be_follow.provide_name?
          n.news_type="friend_follow"
        else
          n.news_type="stranger_follow"
        end
        n.save
        flash[:notice] = "成功关注该用户，之后你会自动获得该用户的一些信息，现在你可以逛逛他的主页"
        format.html { redirect_to user_path(@user) }
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
    @be_follow.user.value=@be_follow.user.value-2
    @be_follow.user.save
    respond_to do |format|
      format.html { redirect_to(user_follows_path(current_user)) }
      format.xml  { head :ok }
    end
  end

end
