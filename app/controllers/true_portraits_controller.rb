class TruePortraitsController < ApplicationController
  # GET /true_portraits
  # GET /true_portraits.xml
  caches_page :show
  before_filter :load_user

  def show
    @true_portrait = @user.true_portrait
    respond_to do |format|
      format.jpg   # show.jpg.flexi (http://mysite.com/photos/123.jpg)
      format.html # show.html.erb
      format.xml  { render :xml => @true_portrait }
    end

  end

  def new
    @true_portrait=@user.build_true_portrait
  end

  # GET /true_portraits/1/edit
  def edit
    @true_portrait = @user.true_portrait
  end

  # POST /true_portraits
  # POST /true_portraits.xml
  def create
    @true_portrait =  @user.build_true_portrait(params[:true_portrait])
    if @true_portrait.save
      redirect_to user_true_portrait_path(@user)
    else
      flash[:notice] = '上传的文件有点问题，请按照要求重新上传。'
      redirect_to user_path(@user)
    end
  end

  # PUT /true_portraits/1
  # PUT /true_portraits/1.xml
  def update
    @true_portrait = @user.true_portrait

    respond_to do |format|
      if @true_portrait.update_attributes(params[:true_portrait])
        flash[:notice] = '头像已更新.'
        format.html { redirect_to(@true_portrait) }
        format.xml  { head :ok }
      else
        format.html { render edit_user_true_portrait_path(@user) }
        format.xml  { render :xml => @true_portrait.errors, :status => :unprocessable_entity }
      end
    end
    expire_true_portrait(@true_portrait)
  end

  # DELETE /true_portraits/1
  # DELETE /true_portraits/1.xml
  def destroy
    @true_portrait = @user.true_portrait.find(params[:id])
    @true_portrait.destroy
    expire_true_portrait(@true_portrait)
  end

  private
  def expire_photo(photo)
    expire_page user_true_portrait_path(photo, :format => :jpg)
  end

  def  load_user
    @user=User.find(session[:user_id])
  end
end
