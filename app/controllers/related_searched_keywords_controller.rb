class RelatedSearchedKeywordsController < ApplicationController
  before_filter :find_keyword
  auto_complete_for :keyword,:name
  def index
    @related_searched_keywords=@keyword.related_searched_keywords
  end

  def new
    @related_searched_keyword=@keyword.related_searched_keywords.build
  end

  def edit
  end

  def show
  end

  def create
    @related_searched_keyword=@keyword.related_searched_keywords.build(params[:related_searched_keyword])
    if @related_searched_keyword.save
      flash[:notice]="修改成功"
      redirect_to keyword_related_searched_keywords_path(@keyword)
    else
      render :action => :new
    end
  end
  private
  def find_keyword
    @keyword=Keyword.find(params[:keyword_id])
  end
end
