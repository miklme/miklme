class RelatedKeywordsController < ApplicationController
  before_filter :find_keyword_page
  auto_complete_for :resource,:keywords
  def index
    @related_keywords=@keyword_page.related_keywords
  end

  def new
    @related_keyword=@keyword_page.related_keywords.build
  end

  def create
    @related_keyword=@keyword_page.related_keywords.build(params[:related_keyword])
    if @related_keyword.save
      flash[:notice]="修改成功"
      redirect_to keyword_page_related_keywords_path(@keyword_page)
    else
      render :action => :new
    end
  end

  def destroy
    related_keyword=@keyword_page.related_keywords.find(params[:id])
    related_keyword.destroy
    redirect_to keyword_page_related_keywords_path(@keyword_page)
  end
  private
  def find_keyword_page
    @user=User.find(current_user)
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
  end
end
