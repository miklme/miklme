class KeywordPagesController < ApplicationController
  before_filter :load_user
  auto_complete_for :resource,:keywords,:limit => 10
  def show
    @keyword_page=KeywordPage.find(params[:id])
    @resources=Resource.search_by_keywords(@keyword_page.keyword,params[:page])
    @related_keywords=@keyword_page.related_keywords
    flash[:keyword]="这个是关于“#{@keyword_page.keyword}”的页面,若想要在本页面中增加条目，需要在“领域”中输入“#{@keyword_page.keyword}”"
    respond_to do |format|
      format.html
      format.xml  { render :xml => @resources }
    end
  end

  # PUT /keyword_pages/1
  # PUT /keyword_pages/1.xml
  def show_film
    @keyword_page=KeywordPage.find(params[:id])
    @film_results=Resource.search_by_keywords_and_form(@keyword_page.keyword,"视频",params[:page])
    @related_keywords=@keyword_page.related_keywords
      render :update do |page|
      page.replace_html "content",:partial => "film_result"
    end
  end

  def show_music
    @keyword_page=KeywordPage.find(params[:id])
    @music_results=Resource.search_by_keywords_and_form(@keyword_page.keyword,"音频",params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :update do |page|
      page.replace_html "content",:partial => "music_result"
    end
  end

  def show_picture
    @keyword_page=KeywordPage.find(params[:id])
    @picture_results=Resource.search_by_keywords_and_form(@keyword_page.keyword,"图片",params[:page])
    @related_keywords=@keyword_page.related_keywords
    render :update do |page|
      page.replace_html "content",:partial => "picture_result"
    end
  end
  
  def show_text
    @keyword_page=KeywordPage.find(params[:id])
    @text_results=Resource.search_by_keywords_and_form(@keyword_page.keyword,"文字、文档",params[:page])
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
