class ResourcesController < ApplicationController
  before_filter :load_user,:only => [:create,:destroy,:edit,:index,:show,:update]
  auto_complete_for :resource,:keywords
  def index
    @resources=@user.resources.find(:all,:order => "created_at DESC")
  end
  
  def show
    @resource = Resource.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
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
        flash[:notice] = '修改完成'
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
 
  def save_link_url_resource
    @resource=current_user.resources.build
    if !params[:resource][:title].blank? and !params[:resource][:keywords].blank? and !flash[:link_url].blank?
      @resource.update_attributes(:title=>params[:resource][:title], :keywords=>params[:resource][:keywords],:link_url => flash[:link_url])
      @resource.save
      render :update do |page|
        page.redirect_to user_path(current_user)
      end
    else
      render :update do |page|
        page.insert_html :top, "new_resource", "<p>请填写完全</p>"
      end
    end
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end

end
