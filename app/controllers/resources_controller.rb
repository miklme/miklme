class ResourcesController < ApplicationController
  before_filter :load_user,:only => [:create,:destroy,:edit,:index,:show,:update]
  auto_complete_for :resource,:keywords
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
 
  def check_content
    @resource = current_user.resources.build
    check_result=check_resource_type(params[:resource][:step_one])
    if check_result=="link_url_resource" and Resource.find_by_link_url(params[:resource][:step_one]).blank?
      @resource.link_url=params[:resource][:step_one]
      session[:link_url]=params[:resource][:step_one]
      @resource.save
      render :update do |page|
        page.replace_html 'new_resource',:partial => "unknown_link_url"
      end
    elsif check_result=="link_url_resource" and Resource.find_by_link_url(params[:resource][:step_one])
      @resource= Resource.find_by_link_url(params[:resource][:step_one])
      render :update do |page|
        page.replace_html 'new_resource',:partial => "known_link_url"
      end
    elsif check_result=="twiiter_resource"
      render :update do |page|
      end
    end
  end

  def save_title_and_keywords
    @resource=Resource.find_by_link_url(session[:link_url])
    @resource.update_attributes(params[:resource])
    @resource.save
    redirect_to user_path(current_user)
    flash[:notice]="资源已成功创时建并被纳入引擎。"
  end
  private
  def load_user
    @user=User.find(params[:user_id])
  end

end
