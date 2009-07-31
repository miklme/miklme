class KeywordPagesController < ApplicationController
  before_filter :load_user
  def show
    @keyword_page=KeywordPage.find(params[:id])
    @resources=Resource.scoped_by_keywords(params[:keywords]).by_owner_value
    @related_keywords=@keyword_page.related_keywords
    respond_to do |format|
      format.html # index.html.erb
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

  # POST /keyword_pages
  # POST /keyword_pages.xml
  def create
    @keyword_page = KeywordPage.new(params[:keyword_page])

    respond_to do |format|
      if @keyword_page.save
        flash[:notice] = 'KeywordPage was successfully created.'
        format.html { redirect_to(@keyword_page) }
        format.xml  { render :xml => @keyword_page, :status => :created, :location => @keyword_page }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @keyword_page.errors, :status => :unprocessable_entity }
      end
    end
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
  def destroy
    @keyword_page = KeywordPage.find(params[:id])
    @keyword_page.destroy

    respond_to do |format|
      format.html { redirect_to(keyword_pages_url) }
      format.xml  { head :ok }
    end
  end
  private
  def load_user
    @user=current_user
  end
end
