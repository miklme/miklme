class ResourcesController < ApplicationController
  before_filter :load_user,:except => :auto_complete_for_keyword_page_keyword
  layout "link_url_resources"
  
  def index
    @resources=Resource.find_by_user(@user,params[:page])
  end

  # GET /resources/1/edit
  def edit
    @resource = @user.resources.find(params[:id])
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

  def authority
    @authority_resources=Resource.authority_resources(@user,params[:page])
  end

  def not_authority
    @not_authority_resources=Resource.not_authority_resources(@user,params[:page])
  end


end
