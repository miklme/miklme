class PortraitsController < ApplicationController
  caches_page :show
  before_filter :load_user

  def show
    @portrait = @user.portrait
    respond_to do |format|
      format.jpg   # show.jpg.flexi (http://mysite.com/photos/123.jpg)
      format.html # show.html.erb
      format.xml  { render :xml => @portrait }
    end

  end

  def new
    @portrait=@user.build_portrait
  end

  # GET /portraits/1/edit
  def edit
    @portrait = @user.portrait
  end

  # POST /portraits
  # POST /portraits.xml
  def create
    @portrait =  @user.build_portrait(params[:portrait])
    if @portrait.save
      redirect_to new_user_true_portrait_path(@user)
    else
      flash[:notice] = '上传的文件有点问题，请按照要求重新上传。'
      redirect_to new_user_portrait_path(@user)
    end
  end

  # PUT /portraits/1
  # PUT /portraits/1.xml
  def update
    @portrait = @user.portrait

    respond_to do |format|
      if @portrait.update_attributes(params[:portrait])
        flash[:notice] = '头像已更新.'
        format.html { redirect_to(@portrait) }
        format.xml  { head :ok }
      else
        format.html { render edit_user_portrait_path(@user) }
        format.xml  { render :xml => @portrait.errors, :status => :unprocessable_entity }
      end
    end
    expire_portrait(@portrait)
  end

  # DELETE /portraits/1
  # DELETE /portraits/1.xml
  def destroy
    @portrait = @user.portrait.find(params[:id])
    @portrait.destroy
    expire_portrait(@portrait)
  end

  private
  def expire_photo(photo)
    expire_page user_portrait_path(photo, :format => :jpg)
  end

  def  load_user
    @user=User.find(session[:user_id])
  end
end
