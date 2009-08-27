class KeywordPagesController < ApplicationController
  before_filter :load_user
  auto_complete_for :resource,:keywords
  def show
    @keyword_page=KeywordPage.find(params[:id])
    @link_url_resources=LinkUrlResource.search_by_keywords(@keyword_page.keyword,params[:page])
    @related_keywords=@keyword_page.related_keywords
    @twitter_resource=TwitterResource.find_by_keywords(@keyword_page.keyword)
    flash[:keyword]="这个页面的关键字是“#{@keyword_page.keyword}”,因此你需要在“关键字”中输入“#{@keyword_page.keyword}”"
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

  def show_film
    @keyword_page=KeywordPage.find(params[:id])
    @film_results=LinkUrlResource.search_by_keywords_and_form(@keyword_page.keyword,"视频",params[:page])
    @related_keywords=@keyword_page.related_keywords
      render :update do |page|
      page.replace_html "content",:partial => "film_result"
    end
  end

  def show_music
    @keyword_page=KeywordPage.find(params[:id])
    @music_results=LinkUrlResource.search_by_keywords_and_form(@keyword_page.keyword,"音频",params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :update do |page|
      page.replace_html "content",:partial => "music_result"
    end
  end

  def show_picture
    @keyword_page=KeywordPage.find(params[:id])
    @picture_results=LinkUrlResource.search_by_keywords_and_form(@keyword_page.keyword,"图片",params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :update do |page|
      page.replace_html "content",:partial => "picture_result"
    end
  end
  
  def show_text
    @keyword_page=KeywordPage.find(params[:id])
    @text_results=LinkUrlResource.search_by_keywords_and_form(@keyword_page.keyword,"文字、文档",params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :update  do |page|
      page.replace_html "content",:partial => "text_result"
    end
  end
  # DELETE /keyword_pages/1
  # DELETE /keyword_pages/1.xml
  private
  def load_user
    @user=current_user
  end
end
