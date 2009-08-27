class ControlledKeywordsController < ApplicationController
  before_filter :load_user
  # GET /keywords
  # GET /keywords.xml
  def index
    @controlled_keywords=@user.controlled_keywords
    @user.followers
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @keywords }
    end
  end

  # GET /keywords/1
  # GET /keywords/1.xml
  def show
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @keyword }
    end
  end

  # GET /keywords/1/edit
  def edit
    @keyword = Keyword.find(params[:id])
  end

  # PUT /keywords/1
  # PUT /keywords/1.xml
  def update
    @keyword = Keyword.find(params[:id])

    respond_to do |format|
      if @keyword.update_attributes(params[:keyword])
        flash[:notice] = 'Keyword was successfully updated.'
        format.html { redirect_to(@keyword) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @keyword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /keywords/1
  # DELETE /keywords/1.xml
  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy

    respond_to do |format|
      format.html { redirect_to(keywords_url) }
      format.xml  { head :ok }
    end
  end

  private
  def load_user
    @user=User.find(params[:user_id])
  end
end
