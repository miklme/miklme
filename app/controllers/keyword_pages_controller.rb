class KeywordPagesController < ApplicationController
  before_filter :load_user,:only => [:index,:new,:destroy,:create,:update,:edit]
  auto_complete_for :keyword_page,:keyword,:limit => 10

  def new
    @keyword_page=@user.keyword_pages.build
    render :layout => "related_keywords"
  end

  def destroy
    keyword_page=@user.keyword_pages.find(params[:id])
    keyword_page.destroy
    redirect_to :back
  end

  def create
    if KeywordPage.find_by_keyword(params[:keyword_page][:keyword]).present?
      @user.keyword_pages<<KeywordPage.find_by_keyword(params[:keyword_page][:keyword])
      flash[:notice]="成功。要查看该领域内容，请点击'Mikl'链接"
    else
      @keyword_page=KeywordPage.create(:keyword => params[:keyword_page][:keyword])
      v=ValueOrder.new
      v.keyword_page=@keyword_page
      v.user=@user
      v.save
      flash[:notice]="要知道，你是第一个进入这个领域的人。想要让更多人认识到你，你最好让更多人关注你，
      或者是进入该领域页面，编辑‘相关领域。’"
    end
    redirect_to edit_user_path(@user)
  end
  
  def show
    @keyword_page=KeywordPage.find(params[:id])
    @resources=Resource.find_by_keyword_page_and_time(@keyword_page,params[:page])
    @related_keywords=@keyword_page.related_keywords
    flash[:keyword]="这个是关于“#{@keyword_page.keyword}”的页面,若想要在本页面中增加条目，需要在“领域”中选择“#{@keyword_page.keyword}”
    ，所以首先你要将这个领域添加进'我的领域'"
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

end
