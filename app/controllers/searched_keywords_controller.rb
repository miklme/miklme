class SearchedKeywordsController < ApplicationController
  # GET /searched_keywords
  # GET /searched_keywords.xml
  def index
    @searched_keywords = SearchedKeyword.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @searched_keywords }
    end
  end

  # GET /searched_keywords/1
  # GET /searched_keywords/1.xml
  def show
    @searched_keyword = SearchedKeyword.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @searched_keyword }
    end
  end

  # GET /searched_keywords/new
  # GET /searched_keywords/new.xml
  def new
    @searched_keyword = SearchedKeyword.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @searched_keyword }
    end
  end

  # GET /searched_keywords/1/edit
  def edit
    @searched_keyword = SearchedKeyword.find(params[:id])
  end

  # POST /searched_keywords
  # POST /searched_keywords.xml
  def create
    @searched_keyword = SearchedKeyword.new(params[:searched_keyword])

    respond_to do |format|
      if @searched_keyword.save
        flash[:notice] = 'SearchedKeyword was successfully created.'
        format.html { redirect_to(@searched_keyword) }
        format.xml  { render :xml => @searched_keyword, :status => :created, :location => @searched_keyword }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @searched_keyword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /searched_keywords/1
  # PUT /searched_keywords/1.xml
  def update
    @searched_keyword = SearchedKeyword.find(params[:id])

    respond_to do |format|
      if @searched_keyword.update_attributes(params[:searched_keyword])
        flash[:notice] = 'SearchedKeyword was successfully updated.'
        format.html { redirect_to(@searched_keyword) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @searched_keyword.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /searched_keywords/1
  # DELETE /searched_keywords/1.xml
  def destroy
    @searched_keyword = SearchedKeyword.find(params[:id])
    @searched_keyword.destroy

    respond_to do |format|
      format.html { redirect_to(searched_keywords_url) }
      format.xml  { head :ok }
    end
  end
end
