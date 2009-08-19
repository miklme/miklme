class KeywordPagesController < ApplicationController
  before_filter :load_user
  auto_complete_for :resource,:keywords
  def show
        keyword_page2=KeywordPage.find_by_keyword(params[:keywords])
    @keyword_page=KeywordPage.find(params[:id])
    @link_url_resources=LinkUrlResource.scoped_by_keywords(@keyword_page.keyword).by_owner_value
    @related_keywords=@keyword_page.related_keywords
    @twitter_resource=TwitterResource.find_by_keywords(@keyword_page.keyword)
    respond_to do |format|
      format.html
      format.xml  { render :xml => @resources }
    end
  end

  # GET /keyword_pages/new
  # GET /keyword_pages/new.xml
  def new
    @keyword_page = KeywordPage.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @keyword_page }
    end
  end

  # GET /keyword_pages/1/edit
  def edit
    @keyword_page=KeywordPage.find(params[:id])
    redirect_to keyword_page_related_keywords_path(@keyword_page)
  end

  # PUT /keyword_pages/1
  # PUT /keyword_pages/1.xml
  def update
    @keyword_page = KeywordPage.find(params[:id])

    respond_to do |format|
      if @keyword_page.update_attributes(params[:keyword_page])
        flash[:notice] = 'KeywordPage was successfully updated.'
        format.html { redirect_to(@keyword_page) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @keyword_page.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /keyword_pages/1
  # DELETE /keyword_pages/1.xml
  private
  def load_user
    @user=current_user
  end
end
