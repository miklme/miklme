class BeFollowsController < ApplicationController
before_filter :load_user  # GET /be_follows.xml
layout "news"
  def index
    @be_follows = @user.be_follows.all

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

  # GET /be_follows/new
  # GET /be_follows/new.xml
  def new
    @be_follow = BeFollow.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @be_follow }
    end
  end

  # GET /be_follows/1/edit
  def edit
    @be_follow = BeFollow.find(params[:id])
  end

  # POST /be_follows
  # POST /be_follows.xml
  def create
    @be_follow = BeFollow.new(params[:be_follow])

    respond_to do |format|
      if @be_follow.save
        flash[:notice] = 'BeFollow was successfully created.'
        format.html { redirect_to(@be_follow) }
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
    @user=current_user
  end
end
