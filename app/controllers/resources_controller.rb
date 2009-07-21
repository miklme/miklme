class ResourcesController < ApplicationController
  before_filter :load_user,:except => [:check_url]
  def index
    @resources=@user.resources
  end
  
  def show
    @resource = Resource.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.xml
  def new
    @resource = @user.resources.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource }
    end
  end
  # GET /resources/1/edit
  def edit
    @resource = @user.resources.find(params[:id])
  end

  # POST /resources
  # POST /resources.xml
  def create
    @resource = @user.resources.build(params[:resource])
    respond_to do |format|
      if @resource.save
        keyword=Keyword.create(:name => params[:resource][:keywords])
        @user.keywords<<keyword
        @user.save
        flash[:notice] = 'Resource was successfully created.'
        format.html { redirect_to user_resources_path(@user) }
        format.xml  { render :xml => @resource, :status => :created, :location => @resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.xml
  def update
    @resource = @user.resources.find(params[:id])

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        flash[:notice] = 'Resource was successfully updated.'
        format.html { redirect_to user_resources_path(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    @resource = Resource.find(params[:id])
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(user_resources_url) }
      format.xml  { head :ok }
    end
  end

 
  private
  def check_url
    if params[:resource][:link_url]=="aaa"
      render :update do |page|
        page.hide "new_resource"
      end
    end
  end

  def load_user
    @user=User.find(params[:user_id])
  end

end
