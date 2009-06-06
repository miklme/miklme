class PortraitsController < ApplicationController
  # GET /portraits
  # GET /portraits.xml
  def index
    @portraits = Portrait.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @portraits }
    end
  end

  # GET /portraits/1
  # GET /portraits/1.xml
  def show
    @portrait = Portrait.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @portrait }
    end
  end

  # GET /portraits/new
  # GET /portraits/new.xml
  def new
    @portrait = Portrait.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @portrait }
    end
  end

  # GET /portraits/1/edit
  def edit
    @portrait = Portrait.find(params[:id])
  end

  # POST /portraits
  # POST /portraits.xml
  def create
    @portrait = Portrait.new(params[:portrait])

    respond_to do |format|
      if @portrait.save
        flash[:notice] = 'Portrait was successfully created.'
        format.html { redirect_to(@portrait) }
        format.xml  { render :xml => @portrait, :status => :created, :location => @portrait }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @portrait.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /portraits/1
  # PUT /portraits/1.xml
  def update
    @portrait = Portrait.find(params[:id])

    respond_to do |format|
      if @portrait.update_attributes(params[:portrait])
        flash[:notice] = 'Portrait was successfully updated.'
        format.html { redirect_to(@portrait) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @portrait.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /portraits/1
  # DELETE /portraits/1.xml
  def destroy
    @portrait = Portrait.find(params[:id])
    @portrait.destroy

    respond_to do |format|
      format.html { redirect_to(portraits_url) }
      format.xml  { head :ok }
    end
  end
end
