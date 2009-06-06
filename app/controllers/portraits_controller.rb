class PortraitsController < ApplicationController
  caches_page :show
  def show
    @portrait = current_user.portrait.find(params[:id])
    respond_to do |format|
      format.jpg   # show.jpg.flexi (http://mysite.com/photos/123.jpg)
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end

  end

  def new
    @portrait = current_user.portrait.new
  end

  # GET /portraits/1/edit
  def edit
    @portrait = current_user.portrait.find(params[:id])
  end

  # POST /portraits
  # POST /portraits.xml
  def create
    @portrait = current_user.portrait.new(params[:portrait])
    if @portrait.save
      redirect_to :action => "new"
    else
      flash[:notice] = '恩...仍然有点小问题，请按照要求重新上传。'
      render :action => 'new'
    end
  end

  # PUT /portraits/1
  # PUT /portraits/1.xml
  def update
    @portrait = current_user.find(params[:id])

    respond_to do |format|
      if @portrait.update_attributes(params[:portrait])
        flash[:notice] = '头像已更新.'
        format.html { redirect_to(@portrait) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @portrait.errors, :status => :unprocessable_entity }
      end
    end
    expire_portrait(@portrait)
  end

  # DELETE /portraits/1
  # DELETE /portraits/1.xml
  def destroy
    @portrait = current_user.portrait.find(params[:id])
    @portrait.destroy
    expire_portrait(@portrait)
  end

  private
  def expire_photo(photo)
    expire_page user_portrait_path(photo, :format => :jpg)
  end

end
