class RelatedKeywordsController < ApplicationController
  auto_complete_for :resource,:keywords
  before_filter :find_keyword_page,:only => [:new,:create,:destroy,:index]
  def index
    @related_keywords=@keyword_page.related_keywords
  end

  def new
    @related_keyword=@keyword_page.related_keywords.build
  end

  def create
    @related_keyword=@keyword_page.related_keywords.build(:name => params[:keywords])
    if @related_keyword.save
      flash[:notice]="修改成功"
      k=KeywordPage.find_by_keyword(@related_keyword.name)
      k.related_keywords.create(:name => @keyword_page.keyword,:auto => true)
      render :update do |page|
        page.redirect_to keyword_page_related_keywords_path(@keyword_page)
      end
    end
  end

  def destroy
    related_keyword=@keyword_page.related_keywords.find(params[:id])
    if !related_keyword.auto?
      related_keyword.destroy
    else
      flash[:notice]="这个关键字是别人关联到你这里的，不能删除"
    end
    redirect_to keyword_page_related_keywords_path(@keyword_page)
  end
  private
  def find_keyword_page
    @user=User.find(current_user)
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
  end
end
