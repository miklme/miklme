class ResourcesController < ApplicationController
  before_filter :load_user,:except => :auto_complete_for_keyword_page_keyword
  skip_before_filter :login_required,:only => [:index]
  
  def index
    @resources=Resource.find_by_user(@user,params[:page])
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


end
