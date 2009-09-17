class RelatedKeywordsController < ApplicationController
  auto_complete_for :keyword_page,:keyword,:limit => 10
  before_filter :find_keyword_page,:except => :auto_complete_for_keyword_page_keyword
  def index
    @related_keywords=@keyword_page.related_keywords
  end

  def new
    @related_keyword=@keyword_page.related_keywords.build
  end

  def create
    @related_keyword=@keyword_page.related_keywords.build(:name => params[:keyword])
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
    related_keyword.destroy
    redirect_to keyword_page_related_keywords_path(@keyword_page)
  end
  private
  def find_keyword_page
    @user=User.find(current_user)
    @keyword_page=KeywordPage.find(params[:keyword_page_id])
  end
end
