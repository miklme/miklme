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

  # POST /be_follows
  # POST /be_follows.xml
  def create
    @be_follow = BeFollow.new(params[:be_follow])
    @be_follow.user=@user
    @be_follow.follower=current_user
    if @be_follow.save
      if params[:keyword_page].present? and @user.last_ip!=current_user.last_ip
        k=KeywordPage.find_by_keyword(params[:keyword_page][:keyword])
        @user.change_value(k,3)
      end
      @user.save
      n=@user.news.create
      n.owner=@user
      n.follower_id=current_user.id
      n.news_type="be_follow"
      n.save
      flash[:notice] = "成功关注该用户，之后你会自动获得该用户的一些信息，现在你可以逛逛他的主页"
      redirect_to user_path(@user)
    else
      render  :action => "new"
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
    @be_follow.user.save
    respond_to do |format|
      format.html { redirect_to(user_follows_path(current_user)) }
      format.xml  { head :ok }
    end
  end

end
