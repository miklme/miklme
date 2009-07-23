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


  def check_resource_type(content)
    if content =~ %r{[a-zA-z]+://[^\s]*}
      "link_url_resource"
    elsif content !~%r{[a-zA-z]+://[^\s]*} and content.length<=139
      "twitter_resource"
    elsif  content !~%r{[a-zA-z]+://[^\s]*} and content.length>=140
      "blog_resource"
    end
  end

  def check_content
    @resource = current_user.resources.build
    check_result=check_resource_type(params[:resource][:step_one])
    if check_result=="link_url_resource"
      @known_resource= Resource.scoped_by_link_url(params[:resource][:step_one]).by_owner_value.first
      flash[:link_url]=params[:resource][:step_one]
      render :update do |page|
        page.replace_html 'new_resource',:partial => "link_url_resources/form"
      end
    elsif check_result=="twitter_resource"
      @resource.resource_type="twitter_resource"
      @resource.keywords=params[:resource][:step_one]
      @resource.save!
      render :update do |page|
        page.replace_html "new_resource",:partial => "twitter_resources/succeed"
        page.insert_html :top,"r",:partial => "resource",:object => @resource
      end
    elsif check_result=="blog_resource"
      render :update do |page|
      end
    end
  end
  
  private
  def load_user
    @user=User.find(params[:user_id])
  end

end
