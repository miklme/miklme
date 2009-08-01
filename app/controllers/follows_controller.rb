class FollowsController < ApplicationController
  before_filter :load_user
  layout "news"
  # GET /follows
  # GET /follows.xml
  def index
    @follows = @user.follows

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @follows }
    end
  end

  # GET /follows/1
  # GET /follows/1.xml
  def show
    @follows = Follows.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @follows }
    end
  end

  # GET /follows/new
  # GET /follows/new.xml
  def new
    @follow = @user.follows.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @follows }
    end
  end

  # GET /follows/1/edit
  def edit
    @follows = Follows.find(params[:id])
  end

  # POST /follows
  # POST /follows.xml
  def create
    @follows = Follows.new(params[:follows])

    respond_to do |format|
      if @follows.save
        flash[:notice] = 'Follows was successfully created.'
        format.html { redirect_to(@follows) }
        format.xml  { render :xml => @follows, :status => :created, :location => @follows }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @follows.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /follows/1
  # PUT /follows/1.xml
  def update
    @follows = Follows.find(params[:id])

    respond_to do |format|
      if @follows.update_attributes(params[:follows])
        flash[:notice] = 'Follows was successfully updated.'
        format.html { redirect_to(@follows) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @follows.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /follows/1
  # DELETE /follows/1.xml
  def destroy
    @follows = Follows.find(params[:id])
    @follows.destroy

    respond_to do |format|
      format.html { redirect_to(follows_url) }
      format.xml  { head :ok }
    end
  end

  private
  def load_user
    @user=current_user
  end
end
